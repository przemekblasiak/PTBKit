//
//  SignUpViewController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 01.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    
// MARK: Lifecycle
    override func viewDidAppear(animated: Bool) {
        
        // Focus on username field
        self.usernameField.becomeFirstResponder()
    }

// MARK: Actions
    @IBAction func goBackAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signUpAction(sender: AnyObject) {
        let username: String = self.usernameField.text
        let password: String = self.passwordField.text
        let repeatPassword: String = self.repeatPasswordField.text
        
        var error: NSError?
        if (username.validateUsername(&error) && password.validatePassword(&error) && repeatPassword.validatePassword(&error)) {
            if (password == repeatPassword) {
                self.signUpWithUsername(username, password: password)
            } else {
                var alert = UIAlertController(type: .Error, message: "Hasło nie jest zgodne z jego powtórzeniem")
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            
            // Present error alert with error message
            var alert = UIAlertController(type: .Error, error: error!)
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
// MARK: Sign up
    func signUpWithUsername(username: String, password: String) {
        
        // Create new user
        var newUser = PFUser()
        newUser.username = username
        newUser.password = password
        
        // Present Progress Alert
        var progressAlert = UIAlertController(title: "Tworzenie konta...", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(progressAlert, animated: true, completion: nil)
        
        // Try to sign up
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                
                // Dismiss Progress Alert
                progressAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    // Log in
                    let presentingController: LoginViewController = self.presentingViewController as LoginViewController
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        presentingController.logInWithUsername(newUser.username, password: newUser.password)
                    })
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
            self.signUpAction(self)
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

}
