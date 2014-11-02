//
//  LoginViewController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 01.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var oba: String {
            return userTextField.text + passwordTextField.text
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let currentUser: PFUser? = PFUser.currentUser()
        if currentUser != nil {
            self.performSegueWithIdentifier("LogInSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    
    // MARK: Button Actions
    @IBAction func signUpAction(sender: AnyObject) {
        
        // Create new user
        var newUser = PFUser()
        newUser.username = userTextField.text
        newUser.password = passwordTextField.text
        
        // Try to sign up
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                
                // Show success and log in after dismiss
                var alert = UIAlertController(title: "Success", message: "The account has been created", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) -> Void in
                    self.logInWithUsername(newUser.username, password: newUser.password)
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let errorString: String! = error.localizedDescription
                
                // Show failure
                var alert = UIAlertController(title: "Failed", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func logInAction(sender: AnyObject) {
        
        let username: String = userTextField.text,
            password: String = passwordTextField.text
        
        // Log In
        logInWithUsername(username, password: password);
    }
    
    // MARK: Log In
    func logInWithUsername(username: String, password: String) {
        
        // Try to log in
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("LogInSegue", sender: self)
            } else {

                // Present Alert
                let errorString: String! = error.localizedDescription
                var alert = UIAlertController(title: "Failed", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}
