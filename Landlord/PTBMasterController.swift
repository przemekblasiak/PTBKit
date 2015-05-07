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
public class PTBMasterController: UITableViewController, UISplitViewControllerDelegate {
    
// MARK: Public
    /**
    Loads objects of the specified Parse class to serve as a data source for the table. Each of the objects is represented by a cell with a title provided by the specified title column.
    */
    public func loadObjects(#className: String, titleColumnName: String) {
        self.objectClassName = className
        self.objectTitleColumnName = titleColumnName
        self.updateObjects()
    }
    
// MARK: Properties
    var detailController: PTBDetailController! { // Read-only computed property
        return (self.splitViewController?.viewControllers[1] as! UINavigationController).topViewController as! PTBDetailController
    }
    
    var objectClassName: String?
    var objectTitleColumnName: String?
    var objects = [PFObject]()

// MARK: Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        // Add an add action
        let addSelector: Selector = Selector("addObject")
        if self.respondsToSelector(addSelector) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: addSelector)
        }
        
        // Add a refresh action
        let updateSelector: Selector = Selector("updateObjects")
        if self.respondsToSelector(updateSelector) {
            self.refreshControl?.addTarget(self, action: updateSelector, forControlEvents: UIControlEvents.ValueChanged)
        }
        
        // Add a log out action
        let logOutSelector: Selector = Selector("logOut")
        if self.respondsToSelector(logOutSelector) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: UIBarButtonItemStyle.Plain, target: self, action: logOutSelector)
        }
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Register notifications
        let userDidLogInSelector: Selector = Selector("userDidLogIn:")
        if self.respondsToSelector(userDidLogInSelector) {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: userDidLogInSelector, name: PTBUserDidLogInNotification, object: nil)
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.presentLoginScreen()
        }
    }
    
// MARK: TableView data source
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = self.objectClassName! + "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        var object: PFObject = self.objects[indexPath.row]
        if (objectTitleColumnName != nil) {
            cell!.textLabel?.text = (object[objectTitleColumnName] as! String)
        }
        
        // Color the cell
        var backgroundView = UIView()
        backgroundView.backgroundColor = PTBSettings.sharedInstance.colorPalette[PTBInteractiveColorKey]
        cell?.selectedBackgroundView = backgroundView
        
        return cell!
    }
    
// MARK: TableView delegate
    // Override to support editing the table view.
    override public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete selected object
            self.removeObject(indexPath: indexPath)
        }
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
// MARK: Updating
    func updateObjects() {
        if (PFUser.currentUser() != nil) {
            
            // Retrieve objects from Parse
            var query = PFQuery(className: self.objectClassName)
            query.whereKey("userId", equalTo: PFUser.currentUser())
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                self.refreshControl?.endRefreshing()
                
                // Succeeded
                if error == nil {
                    self.objects = objects! as! [PFObject]
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
    
    func addObject() {
        if (PFUser.currentUser() != nil) {
        
            // Create a Parse object
            var newObject = PFObject(className: self.objectClassName)
            newObject["userId"] = PFUser.currentUser()
            newObject[self.objectTitleColumnName] = "New"
            
            // Add the object
            self.objects.insert(newObject, atIndex: self.objects.count)
            newObject.saveEventually()

            // Insert new row
            self.tableView.beginUpdates()
            let rowPath = NSIndexPath(forRow: self.objects.count - 1, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([rowPath!], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            
            // Select the row and switch to editing mode
            self.selectItemAtIndexPath(rowPath)
            self.detailController.setEditing(true, animated: true)
        }
    }
    
    func removeObject(#indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDetailView", sender: self) // Present blank detail view
        
        // Delete the object
        tableView.beginUpdates()
        self.objects.removeAtIndex(indexPath.row).deleteInBackgroundWithBlock(nil)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
// MARK: Table interaction
    func refresh() {
        self.tableView.reloadData()
        self.performSegueWithIdentifier("ShowDetailView", sender: self)
    }
    
    func selectItemAtIndexPath(path: NSIndexPath) {
        self.tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: .None)
        self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: .None, animated: false)
        self.performSegueWithIdentifier("ShowDetailView", sender: self)
    }

// MARK: Navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowDetailView") {
            
            // Pass data to detail controller if any row is selected
            if self.tableView.indexPathForSelectedRow() != nil {
                let detailController: PTBDetailController! = (segue.destinationViewController as! UINavigationController).topViewController as? PTBDetailController
                if detailController != nil {
                    detailController.object = self.objects[self.tableView.indexPathForSelectedRow()!.row]
                }
            }
        }
    }
    
// MARK: Login/Logout
    func presentLoginScreen(animated: Bool = true) {
        var storyboard = UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
        var loginController = storyboard.instantiateInitialViewController() as! UIViewController
        loginController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(loginController, animated: animated, completion: nil)
    }
    
    func logOut() {
        
        // Ask to confirm
        var alert = UIAlertController(title: "Confirm", message: "Do you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,
            handler: { (UIAlertAction action) -> Void in
                PFUser.logOut()
                
                // Clear data
                self.objects = []
                self.refresh()
                
                // Go to Login screen
                self.presentLoginScreen()
            }
            ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func userDidLogIn(notification: NSNotification) {
        self.updateObjects()
    }
}
