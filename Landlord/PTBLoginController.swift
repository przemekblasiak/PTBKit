//
//  PTBLoginController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 01.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

let PTBUserDidLogInNotification = "UserDidLogIn"

class PTBLoginController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var interactiveUIElements: [UIButton]!
    @IBOutlet var informativeUIElements: [UILabel]!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: TEMPORARY COLOR
//        self.view.backgroundColor = UIColor(red: 20/255, green: 25/255, blue: 35/255, alpha: 1)
//        for element in self.interactiveUIElements {
//            element.setTitleColor(UIColor(red: 253/255, green: 166/255, blue: 13/255, alpha: 1), forState: .Normal)
//        }
//        for element in self.informativeUIElements {
//            element.textColor = UIColor.whiteColor()
//        }
    }
    
// MARK: Lifecycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.usernameField.becomeFirstResponder()
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
                    self.performLogin()
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
    
    func performLogin() {
        self.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(PTBUserDidLogInNotification, object: self)
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
