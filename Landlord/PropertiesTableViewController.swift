//
//  PropertiesTableViewController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 02.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class PropertiesTableViewController: UITableViewController {
    
    // MARK: Properties
    var properties = [PFObject]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshControl?.beginRefreshing()
        self.updateProperties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var paid: Bool = (property["paid"] as Bool)
        if paid {
            cell.detailTextLabel?.text = "Paid in time"
        } else {
            cell.detailTextLabel?.text = "Not paid yet"
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Actions
    @IBAction func logOutAction(sender: AnyObject) {
        
        // Ask to confirm
        var alert = UIAlertController(title: "Confirm", message: "Want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,
            handler: { (UIAlertAction action) -> Void in
                PFUser.logOut()
                
                // Clear data
                self.properties = []
                
                // Go to Log In screen
                self.navigationController?.popViewControllerAnimated(true)
            }
        ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshAction(sender: UIRefreshControl) {
        updateProperties()
    }
    
    // MARK: Updating
    func updateProperties() {
        var query = PFQuery(className:"Properties")
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
                let errorString: String! = error.localizedDescription
                var alert = UIAlertController(title: "Failed", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
