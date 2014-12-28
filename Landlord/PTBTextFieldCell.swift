//
//  PTBTextFieldCell.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 15.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

class PTBTextFieldCell: PTBTableViewCell {
    
// MARK: Outlets
    @IBOutlet weak var textField: UITextField!
    
    override func setValue(value: AnyObject) {
        self.textField.text = value as String
    }
    override func getValue() -> AnyObject {
        return self.textField.text
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.textField.enabled = editing
    }
}
