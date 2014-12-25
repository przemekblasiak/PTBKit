//
//  TenantsController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 24.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class TenantsController: PTBTableViewController {
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the table
        self.itemClassName = "Tenant"
        self.itemTitleColumnName = "name"
        
        // Add a log out action
        let logOutSelector: Selector = Selector("logOut")
        if self.respondsToSelector(logOutSelector) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Wyloguj", style: UIBarButtonItemStyle.Plain, target: self, action: logOutSelector)
        }
    }
    
// MARK: Log in/out
    func logOut() {
        
        // Ask to confirm
        var alert = UIAlertController(title: "Potwierdzenie", message: "Chcesz się wylogować?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Anuluj", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Tak", style: UIAlertActionStyle.Default,
            handler: { (UIAlertAction action) -> Void in
                PFUser.logOut()
                
                // Clear data
                self.items = []
                
                // Go to Log In screen
                self.performSegueWithIdentifier("LogOutSegue", sender: self)
            }
            ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
// MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowDetailController") {
            
            // Pass data to detail controller
            let detailController: PTBDetailController! = (segue.destinationViewController as UINavigationController).topViewController as? PTBDetailController
            if detailController != nil {
                detailController.item = self.items[self.tableView.indexPathForSelectedRow()!.row]
            }
        }
    }
}