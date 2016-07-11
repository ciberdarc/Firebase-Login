//
//  HomeViewController.swift
//  LoginApp
//
//  Created by Alexis Araujo on 7/8/16.
//  Copyright © 2016 Alexis Araujo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func didTapLogout(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LogInView")
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid
            
            
            self.nameLabel.text = name
            
            
            //servicio de almacenamiento
            let storage = FIRStorage.storage()
            
            
            //refer your storage service
            let storageRef = storage.referenceForURL("gs://loginapp-93710.appspot.com")
            
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
            
            // Create local filesystem URL
            //let localURL: NSURL! = NSURL(string: "file:///local/images/island.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print("Unable to download image")
                } else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    if (data != nil){
                        print("User already has an image, no need to dowload from facebook")
                        self.profilePic.image = UIImage(data:data!)
                    }
                    
                }
            }
            
            if(self.profilePic.image == nil)
            {
            var profile = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300,"widht":300, "redirect":false],HTTPMethod: "GET")
            profile.startWithCompletionHandler({(connection, result, error) -> Void in
                // Handle the result
                
                if(error == nil) {
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.objectForKey("data")
                    
                    let urlPic = (data?.objectForKey("url"))! as! String
                    
                    if let imagedata = NSData(contentsOfURL: NSURL(string:urlPic)!){
                       
                        let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                        
                        let uploadTask = profilePicRef.putData(imagedata, metadata: nil) {metadata, error in
                            
                            if(error == nil) {
                                //size content type
                                let downloadURL = metadata!.downloadURL
                            }
                            else {
                                print("Error in downloading image")
                            }
                        }
                        self.profilePic.image = UIImage(data:imagedata)
                    }
                }
            })
         }//end if

            
        } else {
            // No user is signed in.
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
