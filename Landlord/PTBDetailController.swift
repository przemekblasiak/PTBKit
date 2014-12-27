//
//  PTBDetailController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 14.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class PTBDetailController: UITableViewController {
    
// MARK: Properties
    var item: PFObject!
    var sectionNames = [String]()
    var cellInfos = [[Dictionary<String, AnyObject>]]()
    var shouldSaveChanges = true
    var cancelButton: UIBarButtonItem!
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set grouped style
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        
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
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.tableView.editing {
            self.saveChanges()
        }
    }

// MARK: Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionNames[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellInfos[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellInfo = self.cellInfos[indexPath.section][indexPath.row]
        
        var cell: PTBTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellInfo["Identifier"] as String, forIndexPath: indexPath) as PTBTableViewCell
        
        // When no row is selected //TODO: Present other controller in the situation
        if self.item != nil {
            cell.setText(self.item[cellInfo["ColumnName"] as String] as String)
        }
        
        return cell
    }
    
// MARK: Private
    func addCell(#style: PTBTableViewCellStyle, sectionName: String, columnName: String) {
        
        var cellIdentifier: String!
        switch style {
        case .TextView:
            cellIdentifier = "TextViewCell"
        case .TextField:
            cellIdentifier = "TextFieldCell"
        case .Switch:
            cellIdentifier = "SwitchCell"
        default:
            println("PTB: Style not handled")
        }
        
        var cellInfo = Dictionary<String, AnyObject>()
        cellInfo["Identifier"] = cellIdentifier as String
        cellInfo["ColumnName"] = columnName
        
        // Find section number
        var sectionNumber: Int! = find(self.sectionNames, sectionName)
        if sectionNumber == nil { // It is a new section
            self.sectionNames.append(sectionName)
            self.cellInfos.append([cellInfo])
        } else {
            self.cellInfos[sectionNumber].append(cellInfo)
        }
    }
    
// MARK: Editing
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if editing {
            // TODO: Make fields editable etc.
        } else {
            // TODO: Make fields readonly etc.
            
            if shouldSaveChanges {
                self.saveChanges()
            } else {
                self.resetFieldValues()
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
    
    // Disable insert/delete styles
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    // Disable indentation
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func saveChanges() {
        // TODO: Save changes
    }
    
    func resetFieldValues() {
        // TODO: Reset values of all fields
    }
    
// MARK: Button actions
    func cancelPressed(button: UIBarButtonItem) {
        self.shouldSaveChanges = false
        self.setEditing(false, animated: true)
    }
    
        override func setEditing(editing: Bool, animated: Bool) {
            super.setEditing(editing, animated: true)
            
            if editing {
                // TODO: Make fields editable, rearrange them etc.
            } else {
                // TODO: Make fields readonly, rearrange them etc.
                
                if shouldSaveChanges {
                    self.saveChanges()
                } else {
                    self.resetFieldValues()
                    self.shouldSaveChanges = true
                }
            }
            
            showCancelButton(editing)
        }
}
