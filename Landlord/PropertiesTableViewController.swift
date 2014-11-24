//
//  PropertiesTableViewController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 02.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class PropertiesTableViewController: PBTableViewController {
    
    // MARK: Properties
    var properties = [PFObject]()
    var propertyTypes = Array<PFObject>()
    var defaultPropertyType = PFObject(className: "PropertyType")
    var detailViewController = PropertyDetailViewController()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailViewController = self.splitViewController?.viewControllers[1] as PropertyDetailViewController

        // Set property types
        let typesQuery = PFQuery(className: "PropertyType")
        typesQuery.findObjectsInBackgroundWithBlock {
            (propertyTypes: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.propertyTypes = propertyTypes as [PFObject]
                
                // Set default PropertyType
                self.defaultPropertyType = self.propertyTypes[0]
                for (index, propertyType) in enumerate(self.propertyTypes) {
                    if (propertyType["name"] as String == "Apartment") {
                        self.defaultPropertyType = propertyType
                    }
                }
            }
        }
        
        // Select first item on the list
        let firstItemPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.selectRowAtIndexPath(firstItemPath, animated: false, scrollPosition: .None)
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
         self.updateProperties()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.properties.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PropertyCell", forIndexPath: indexPath) as UITableViewCell

        var property: PFObject = self.properties[indexPath.row]
        cell.textLabel.text = (property["address"] as String)

        return cell
    }

    // MARK: - Table view delegate
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete
            properties.removeAtIndex(indexPath.row).deleteInBackgroundWithBlock(nil)
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Change address in Detail View
        self.detailViewController.addressLabel.text = self.properties[indexPath.row]["address"] as String?
    }
   
    // MARK: Actions
    @IBAction func addAction(sender: AnyObject) {
        
        // Create and add new Property
        var newProperty = PFObject(className: "Property")
        newProperty["userId"] = PFUser.currentUser()
        newProperty["typeId"] = self.defaultPropertyType
        newProperty["address"] = "Nowa nieruchomość"
        newProperty["withGarage"] = false
        
        // Add new Property
        self.properties.insert(newProperty, atIndex: self.properties.count)
        newProperty.saveInBackgroundWithBlock(nil)
        
        // Insert new row
        self.tableView.beginUpdates()
        var indexPath = NSIndexPath(forRow: self.properties.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        
        // Ask to confirm
        var alert = UIAlertController(title: "Potwierdzenie", message: "Chcesz się wylogować?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Anuluj", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Tak", style: UIAlertActionStyle.Default,
            handler: { (UIAlertAction action) -> Void in
                PFUser.logOut()
                
                // Clear data
                self.properties = []
                
                // Go to Log In screen
                self.performSegueWithIdentifier("LogOutSegue", sender: self)
            }
        ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshAction(sender: UIRefreshControl) {
        updateProperties()
    }
    
    // MARK: Updating
    func updateProperties() {
        var query = PFQuery(className:"Property")
        query.whereKey("userId", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            // Succeeded
            if error == nil {
                self.properties = objects! as [PFObject]
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                
            // Failed
            } else {
                
                // Present Alert
                var alert = UIAlertController(type: .Error, code: error.code)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
