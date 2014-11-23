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
    
    // MARK: Properties
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!

    // MARK: Lifecycle
    override func viewDidAppear(animated: Bool) {
        let currentUser: PFUser? = PFUser.currentUser()
        if currentUser != nil {
            self.performSegueWithIdentifier("LogInSegue", sender: self)
        }
    }
    
    // MARK: Button Actions
    @IBAction func signUpAction(sender: AnyObject) {
        let (fieldsAreValid: Bool, errorString: String) = self.fieldsAreValid()
        
        if fieldsAreValid {
            let username = userTextField.text,
                password = passwordTextField.text
            
            // Sign up
            self.signUpWithUsername(username, password: password)
        } else {
            
            // Present error alert with error message
            var alert = UIAlertController(errorMessage: errorString)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func logInAction(sender: AnyObject) {
        let (fieldsAreValid: Bool, errorString: String) = self.fieldsAreValid()
        
        if fieldsAreValid {
            let username: String = userTextField.text,
                password: String = passwordTextField.text
            
            // Log in
            self.logInWithUsername(username, password: password);
        } else {
            
            // Present alert with error message
            var alert = UIAlertController(errorMessage: errorString)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Private
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
                let errorString: String! = error.localizedDescription
                
                // Dismiss Progress Alert
                progressAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    // Show failure
                    var alert = UIAlertController(errorMessage: errorString)
                    self.presentViewController(alert, animated: true, completion: nil)

                })
            }
        }
    }
    
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
                    self.logInWithUsername(newUser.username, password: newUser.password)
                })
            } else {
                let errorString: String! = error.localizedDescription
                
                // Dismiss Progress Alert
                progressAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    // Show failure
                    var alert = UIAlertController(errorMessage: errorString)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }

    func fieldsAreValid() -> (valid: Bool, errorString: String) {
        
        // Check username
        var validationResult = self.userTextField.text.isUsernameValid()
        if !validationResult.valid {
            return validationResult
        }
        
        // Check password
        validationResult = self.passwordTextField.text.isPasswordValid()
        if !validationResult.valid {
            return validationResult
        }
        
        return (true, "")
    }
    
}

//TODO: Obsłużenie kodów błędu