//
//  PTBMasterController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 18.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class PTBMasterController: UITableViewController {

// MARK: Properties
    // Subclass configurables
    var itemClassName: String?
    var itemTitleColumnName: String?
    var itemSubtitleColumnName: String?
    
    var items = [PFObject]()

// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateItems()
    }
    
// MARK: - Table view data source
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
        if (itemSubtitleColumnName != nil) {
            cell!.detailTextLabel?.text = (item[itemSubtitleColumnName] as String)
        }
        
        return cell!
    }
    
// MARK: TableView delegate
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete selected item
            self.items.removeAtIndex(indexPath.row).deleteInBackgroundWithBlock(nil)
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
    
// MARK: Update data
    func updateItems() {
        
        // Remember current selection
        let selectedRowPath: NSIndexPath? = self.tableView?.indexPathForSelectedRow()?
        
        if (self.itemClassName != nil) {
            var query = PFQuery(className: self.itemClassName)
            query.whereKey("userId", equalTo: PFUser.currentUser())
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                self.refreshControl?.endRefreshing()
                
                // Succeeded
                if error == nil {
                    self.items = objects! as [PFObject]
                    self.tableView.reloadData()
                    
                    // Preserve previously selected row
                    if selectedRowPath != nil {
                        self.tableView?.selectRowAtIndexPath(selectedRowPath, animated: false, scrollPosition: .None)
                    }
                    
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
        
        // Select the row
        self.selectItemAtIndexPath(rowPath)
    }
    
// MARK: Table interaction
    func refresh() {
        
        // Remember selected row, then reload table, and reselect the row
        let selectedRowPath: NSIndexPath! = self.tableView.indexPathForSelectedRow()?
        self.tableView.reloadData()
        if selectedRowPath != nil {
            self.tableView.selectRowAtIndexPath(selectedRowPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
    }
    
    func selectItemAtIndexPath(path: NSIndexPath) {
        self.tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: .None)
        self.tableView(self.tableView, didSelectRowAtIndexPath: path)
        self.tableView.scrollToRowAtIndexPath(path, atScrollPosition: .None, animated: true)
        self.performSegueWithIdentifier("ShowDetailController", sender: self)
    }
}