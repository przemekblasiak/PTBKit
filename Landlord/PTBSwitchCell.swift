//
//  PTBSwitchCell.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 23.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

class PTBSwitchCell: PTBTableViewCell {

    // MARK: Outlets
    @IBOutlet weak var yesNoSwitch: UISwitch!
    @IBOutlet weak var switchTitleLabel: UILabel!
    
    override func setValue(value: AnyObject) {
        self.yesNoSwitch.on = value as Bool
    }
    
    override func getValue() -> AnyObject {
        return self.yesNoSwitch.on
    }
    
    override func setName(name: String) {
        self.switchTitleLabel.text = name
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.yesNoSwitch.enabled = editing
    }
}
