//
//  ProfileTableViewController.swift
//  LoginApp
//
//  Created by Alexis Araujo on 7/11/16.
//  Copyright © 2016 Alexis Araujo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ProfileTableViewController: UITableViewController {
    
    //Creacion de array
    var about = ["Gender","Age","Phone","Email","Website","Bio"]
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    
    @IBAction func didTapUpdate(sender: AnyObject) {
        var index = 0
        while index<about.count{
           
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            let cell: TextInputTableView? = (self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableView)
            
            if cell?.myTextField.text != ""{
                
                let item:String = (cell?.myTextField.text)!
                
                switch about[index] {
                    
                case "Gender":
                    self.ref.child("\(user!.uid)/gender").setValue(item)
                case "Age":
                    self.ref.child("\(user!.uid)/age").setValue(item)
                case "Phone":
                    self.ref.child("\(user!.uid)/phone").setValue(item)
                case "Email":
                    self.ref.child("\(user!.uid)/email").setValue(item)
                case "Website":
                    self.ref.child("\(user!.uid)/website").setValue(item)
                case "Bio":
                    self.ref.child("\(user!.uid)/bio").setValue(item)
                default:
                    print("Dont Update")
                } //end switch
                
                
            }//end if
            index+=1
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        let refHandle = self.ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            let usersDict = snapshot.value as! NSDictionary
                        print(usersDict)
           let userDetail = usersDict.objectForKey(self.user!.uid)!


        
            var index = 0
           while index<self.about.count{

               let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! TextInputTableView?
            
               let field: String = (cell?.myTextField.placeholder?.lowercaseString)!
            
               switch field {
                
                 case "gender":
                      cell?.configure(userDetail.objectForKey("gender") as? String, placeholder: "Gender")
                    case "age":
                        cell?.configure(userDetail.objectForKey("bio") as? String, placeholder: "Age")
                    case "phone":
                        cell?.configure(userDetail.objectForKey("email") as? String, placeholder: "Phone")
                    case "email":
                        cell?.configure(userDetail.objectForKey("gender") as? String, placeholder: "Email")
                    case "website":
                        cell?.configure(userDetail.objectForKey("phone") as? String, placeholder: "Website")
                    case "bio":
                        cell?.configure(userDetail.objectForKey("website") as? String, placeholder: "Bio")
                    default:
                       ""
                  } //end switch
               
              index+=1
           }
           
  })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TextInputTableView

        // Configure the cell...
        cell.configure("", placeholder: "\(about[indexPath.row])")
        
        //cell.myTextField.placeholder = about[indexPath.row]

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
