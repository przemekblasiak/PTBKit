//
//  PTBSwitchCell.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 23.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

/// Represents a cell with a switch that can be used in PTBDetailController's table view.
class PTBSwitchCell: UITableViewCell, PTBDetailCell {

    var columnName: String!
    var name: String! {
        didSet {
            self.switchTitleLabel.text = self.name
        }
    }
    
    @IBOutlet weak var yesNoSwitch: UISwitch!
    @IBOutlet weak var switchTitleLabel: UILabel!
    
    func setValue(value: AnyObject) {
        self.yesNoSwitch.on = value as! Bool
    }
    
    func getValue() -> AnyObject {
        return self.yesNoSwitch.on
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.yesNoSwitch.enabled = editing
    }
}
