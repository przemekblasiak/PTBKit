//
//  PTBDetailController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 14.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

/**
The PTBDetailController class is a UITableViewController subclass responsible for displaying values of each column of a specified Parse object.
*/
public class PTBDetailController: UITableViewController {

// MARK: Public
    /**
    Appends a cell with the given name and style to the specified section in the table. Provided column name determines which column should be used as a data source for the cell.
    */
    func appendCell(name cellName: String, style: PTBDetailCellStyle, forColumnName columnName: String, toSection sectionName: String) {
        if self.object != nil {
            var cellInfo = Dictionary<String, AnyObject>()
            cellInfo["Identifier"] = style.cellIdentifier
            cellInfo["ColumnName"] = columnName
            cellInfo["CellName"] = cellName
            
            // Find section number
            var sectionNumber: Int! = find(self.sectionNames, sectionName)
            if sectionNumber == nil { // It is a new section
                self.sectionNames.append(sectionName)
                self.cellInfos.append([cellInfo])
            } else {
                self.cellInfos[sectionNumber].append(cellInfo)
            }
        }
    }

// MARK: Properties
    weak var object: PFObject!
    var sectionNames = [String]()
    var cellInfos = [[Dictionary<String, AnyObject>]]()
    var shouldSaveChanges = true
    var cancelButton: UIBarButtonItem!
    var masterController: PTBMasterController!
    
// MARK: Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.masterController = (self.splitViewController?.viewControllers[0] as! UINavigationController).topViewController as! PTBMasterController
        
        if self.object != nil {
            
            // Set grouped style
            self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
            
            self.tableView.allowsSelection = false
            
            // Set estimated row height for the scroll indicator to assume
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 60
            
            // Register reusable cells
            var nib = UINib(nibName: "PTBTextViewCell", bundle: NSBundle.mainBundle())
            self.tableView.registerNib(nib, forCellReuseIdentifier: "TextViewCell")
            nib = UINib(nibName: "PTBTextFieldCell", bundle: NSBundle.mainBundle())
            self.tableView.registerNib(nib, forCellReuseIdentifier: "TextFieldCell")
            nib = UINib(nibName: "PTBSwitchCell", bundle: NSBundle.mainBundle())
            self.tableView.registerNib(nib, forCellReuseIdentifier: "SwitchCell")
            
            // Enable editting
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
            self.cancelButton = UIBarButtonItem(title: "Anuluj", style: .Plain, target: self, action: "cancelPressed:")
            
            self.title = "Szczegóły"
        } else {
            self.tableView.hidden = true
        }
    }
    
    override public func viewWillDisappear(animated: Bool) {
        if self.tableView.editing && self.shouldSaveChanges {
            self.saveChanges()
        }
    }

// MARK: TableView data source
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionNames[section]
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellInfos[section].count
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellInfo = self.cellInfos[indexPath.section][indexPath.row]
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellInfo["Identifier"] as! String, forIndexPath: indexPath) as! UITableViewCell
        
        // When no row is selected
        if self.object != nil {
            if let detailCell = cell as? PTBDetailCell {
                detailCell.name = cellInfo["CellName"] as! String
                if let value: AnyObject = self.object[cellInfo["ColumnName"] as! String] {
                    detailCell.setValue(value)
                }
            }
        }
        
        return cell
    }
    
    override public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override public func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
// MARK: Editing
    override public func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if !editing {
            if shouldSaveChanges {
                self.saveChanges()
            } else {
                self.tableView.reloadData() // Restore field values to previous state
                self.shouldSaveChanges = true
            }
        }
        
        showCancelButton(editing)
    }
    
    func showCancelButton(shouldShow: Bool) {
        if shouldShow {
            self.navigationItem.setLeftBarButtonItem(self.cancelButton, animated: true)
        } else {
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        }
    }
    
    func saveChanges() {
        if self.object != nil {
            
            // Apply and save changes
            for (var section = 0; section < self.cellInfos.count; ++section) {
                for (var row = 0; row < self.cellInfos[section].count; ++row) {
                    let cellInfo = self.cellInfos[section][row]
                    let cell: PTBDetailCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as! PTBDetailCell
                    self.object[cellInfo["ColumnName"] as! String] = cell.getValue()
                }
            }
            self.object.saveEventually()
            
            // Update row title in master
            if self.masterController != nil {
                if let rowIndex = find(self.masterController.objects, self.object) {
                    let cell = self.masterController.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: 0))!
                    cell.textLabel?.text = self.object[self.masterController.objectTitleColumnName!] as? String
                }
            }
        }
    }
    
    func cancel() {
        self.shouldSaveChanges = false
        self.setEditing(false, animated: true)
    }
    
// MARK: Button actions
    func cancelPressed(button: UIBarButtonItem) {
        self.cancel()
    }
}
