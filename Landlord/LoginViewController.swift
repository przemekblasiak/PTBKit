//
//  LoginViewController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 01.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
// MARK: Lifecycle
    override func viewDidAppear(animated: Bool) {
        let currentUser: PFUser? = PFUser.currentUser()
        if currentUser != nil {
            self.performSegueWithIdentifier("LogInSegue", sender: self)
        } else {
            
            // Focus on username field
            self.usernameField.becomeFirstResponder()
        }
    }
    
// MARK: Button Actions
    @IBAction func logInAction(sender: AnyObject) {
        
        let username: String = usernameField.text
        let password: String = passwordField.text
        
        var error: NSError?
        if (username.isValidUsername(&error) && password.isValidPassword(&error)) {
            
            // Log in
            self.logInWithUsername(username, password: password);
        } else {
            
            // Present alert with error message
            var alert = UIAlertController(type: .Error, error: error!)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
// MARK: Log in
    func logInWithUsername(username: String, password: String) {
        
        // Present Progress Alert //TODO: Change to real progress bar
        var progressAlert = UIAlertController(title: "Logowanie...", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(progressAlert, animated: true, completion: nil)
        
        // Try to log in
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            
            if user != nil {
                
                // Dismiss Progress Alert
                progressAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    // Segue to next screen
                    self.performSegueWithIdentifier("LogInSegue", sender: self)
                })
            } else {
                
                // Dismiss Progress Alert
                progressAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    // Show failure
                    var alert = UIAlertController(type: .Error, error: error)
                    self.presentViewController(alert, animated: true, completion: nil)

                })
            }
        }
    }
    
    
// MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Next as return button, for other fields
        let nextTag: Int = textField.tag + 1
        if let nextResponder: UIResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            self.logInAction(self)
        }
        
        return true
    }
    
// Set return key type to Next, or Done
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // Set Next as return key until there is no next field
        let nextTag: Int = textField.tag + 1
        if let nextField: UITextField = textField.superview?.viewWithTag(nextTag) as? UITextField {
            textField.returnKeyType = UIReturnKeyType.Next
        } else {
            textField.returnKeyType = UIReturnKeyType.Done
        }
        
        return true
    }
    
// MARK: Ungrouped
}