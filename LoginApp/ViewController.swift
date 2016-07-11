//
//  ViewController.swift
//  LoginApp
//
//  Created by Alexis Araujo on 7/6/16.
//  Copyright © 2016 Alexis Araujo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FBSDKCoreKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.hidden = true
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                // Mover al usuario que se conecte a la pantalla de inicio
               let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarControllerView")
                self.presentViewController(homeViewController, animated: true, completion: nil)
                
                
            } else {
                // No user is signed in.
                //Mostrar al usuario el boton de login
                // Optional: Place the button in the center of your view.
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.view!.addSubview(self.loginButton)
                self.loginButton.hidden = false
            }
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        self.loginButton.hidden = true
        aivLoadingSpinner.startAnimating()
        if(error != nil){
            //handle errors here
            self.loginButton.hidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else if(result.isCancelled){
            //handle tha cancel event
            self.loginButton.hidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else {
    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            print("User logged in to Firebase App")
             }
        }
  
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User did Logout")
    }

}

