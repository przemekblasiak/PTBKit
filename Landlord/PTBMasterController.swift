//
//  PTBMasterController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 18.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

/**
The PTBMasterController class is a UITableViewController subclass responsible for displaying each object of a given Parse class as a row.
*/
class PTBMasterController: UITableViewController, UISplitViewControllerDelegate {

// MARK: Public properties
    var detailController: PTBDetailController! { // Read-only computed property
        return (self.splitViewController?.viewControllers[1] as UINavigationController).topViewController as PTBDetailController
    }
    
// MARK: Public methods
    func populate(#className: String, columnName: String) {
        self.itemClassName = className
        self.itemTitleColumnName = columnName
        self.updateItems()
    }
    
// MARK: Private properties
    var itemClassName: String?
    var itemTitleColumnName: String?
    var items = [PFObject]()

// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        // Add an add action
        let addItemSelector: Selector = Selector("addItem")
        if self.respondsToSelector(addItemSelector) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: addItemSelector)
        }
        
        // Add a refresh action
        let updateItemsSelector: Selector = Selector("updateItems")
        if self.respondsToSelector(updateItemsSelector) {
            self.refreshControl?.addTarget(self, action: updateItemsSelector, forControlEvents: UIControlEvents.ValueChanged)
        }
        
        // Add a log out action
        let logOutSelector: Selector = Selector("logOut")
        if self.respondsToSelector(logOutSelector) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Wyloguj", style: UIBarButtonItemStyle.Plain, target: self, action: logOutSelector)
        }
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Register notifications
        let userDidLogInSelector: Selector = Selector("userDidLogIn:")
        if self.respondsToSelector(userDidLogInSelector) {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: userDidLogInSelector, name: PTBUserDidLogInNotification, object: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.presentLoginScreen()
        }
    }
    
// MARK: - TableView data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = self.itemClassName! + "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        var item: PFObject = self.items[indexPath.row]
        if (itemTitleColumnName != nil) {
            cell!.textLabel?.text = (item[itemTitleColumnName] as String)
        }
        
        return cell!
    }
    
// MARK: TableView delegate
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete selected item
            self.removeItem(indexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
// MARK: Update data
    func updateItems() {
        if (PFUser.currentUser() != nil) {
            var query = PFQuery(className: self.itemClassName)
            query.whereKey("userId", equalTo: PFUser.currentUser())
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                self.refreshControl?.endRefreshing()
                
                // Succeeded
                if error == nil {
                    self.items = objects! as [PFObject]
                    self.refresh()
                    
                // Failed
                } else {
                    
                    // Present Alert
                    var alert = UIAlertController(type: .Error, error: error)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func addItem() {
        if (PFUser.currentUser() != nil) {
        
            // Create an item
            var newItem = PFObject(className: self.itemClassName)
            newItem["userId"] = PFUser.currentUser()
            newItem[self.itemTitleColumnName] = "Nowy"
            
            // Add the item
            self.items.insert(newItem, atIndex: self.items.count)
            newItem.saveEventually()

            // Insert new row
            self.tableView.beginUpdates()
            let rowPath = NSIndexPath(forRow: self.items.count - 1, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([rowPath!], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            
            self.selectItemAtIndexPath(rowPath)
            self.detailController.setEditing(true, animated: true)
        }
    }
    
    func removeItem(#indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("ShowDetailView", sender: self) // Present blank detail view
        
        // Delete the item
        tableView.beginUpdates()
        self.items.removeAtIndex(indexPath.row).deleteInBackgroundWithBlock(nil)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
// MARK: Table interaction
    func refresh() {
        
        // TODO: Preserve selection
        self.tableView.reloadData()
    }
    
    func selectItemAtIndexPath(path: NSIndexPath) {
        self.tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: .None)
        self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: .None, animated: false)
        self.performSegueWithIdentifier("ShowDetailView", sender: self)
    }

// MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowDetailView") {
            
            // Pass data to detail controller if any row is selected
            if self.tableView.indexPathForSelectedRow() != nil {
                let detailController: PTBDetailController! = (segue.destinationViewController as UINavigationController).topViewController as? PTBDetailController
                if detailController != nil {
                    detailController.item = self.items[self.tableView.indexPathForSelectedRow()!.row]
                }
            }
        }
    }
    
// MARK: Login/Logout
    func presentLoginScreen(animated: Bool = true) {
        var storyboard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
        var PTBLoginController = storyboard.instantiateInitialViewController() as UIViewController
        self.presentViewController(PTBLoginController, animated: animated, completion: nil)
    }
    
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
                self.presentLoginScreen()
            }
            ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func userDidLogIn(notification: NSNotification) {
        self.updateItems()
    }
}
