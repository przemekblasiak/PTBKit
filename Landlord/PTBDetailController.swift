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
    var masterController: PTBMasterController!
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.masterController = (self.splitViewController!.viewControllers[0] as UINavigationController).topViewController as PTBMasterController
        
        if self.item != nil {
            
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
            
            self.title = "Szczegóły"
        } else {
            self.tableView.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.tableView.editing {
            self.saveChanges()
        }
    }

// MARK: TableView data source
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
            cell.setName(cellInfo["CellName"] as String)
            if let value: AnyObject = self.item[cellInfo["ColumnName"] as String] {
                cell.setValue(value)
            } else {
                let columnName = cellInfo["ColumnName"] as String
                println("PTB: There is no column named \"\(columnName)\" in the Parse object")
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
// MARK: Private
    func addCell(#style: PTBTableViewCellStyle, sectionName: String, cellName: String, columnName: String) {
        if self.item != nil {
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
    
// MARK: Editing
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        if !editing {
            if shouldSaveChanges {
                self.saveChanges()
            } else {
                self.tableView.reloadData() // Reset field values
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
        for (var section = 0; section < self.cellInfos.count; ++section) {
            for (var row = 0; row < self.cellInfos[section].count; ++row) {
                let cellInfo = self.cellInfos[section][row]
                let cell: PTBTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) as PTBTableViewCell
                if self.item != nil { // TODO: Remove after implementing seperate VC for no selection
                    self.item[cellInfo["ColumnName"] as String] = cell.getValue()
                }
            }
        }
        
        if self.masterController != nil {
            self.masterController.refresh()
        }
        
        self.item.saveEventually() //TODO: Why does it have to be AFTER the refresh
    }
    
// MARK: Button actions
    func cancelPressed(button: UIBarButtonItem) {
        self.shouldSaveChanges = false
        self.setEditing(false, animated: true)
    }
}
