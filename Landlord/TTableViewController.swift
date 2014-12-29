//
//  TTableViewController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 29.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

class TTableViewController: UITableViewController {
        
        let Items = ["Altitude","Distance","Groundspeed"]
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.Items.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
            cell.textLabel?.text = self.Items[indexPath.row]
            return cell
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}