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
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Color UI
        let colorPalette = PTBSettings.sharedInstance.colorPalette
        for element in self.buttons {
            element.setTitleColor(colorPalette[PTBInteractiveColorKey], forState: .Normal)
        }
        for element in self.labels {
            element.textColor = colorPalette[PTBInformativeColorKey]
        }
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
        
        // Present Progress Alert
        var progressAlert = UIAlertController(title: "Logowanie...", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(progressAlert, animated: true, completion: nil)
        
        // Log in
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
                
            // Dismiss Progress Alert
            progressAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                // Succeeded
                if error == nil {
                    
                    // Segue to next screen
                    self.performLogin()
                    
                // Failed
                } else {
                    
                    // Show failure
                    var alert = UIAlertController(type: .Error, error: error)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
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
}
