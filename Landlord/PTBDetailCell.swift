//
//  PTBDetailCell.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 19.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

/// The style of the table view cell.
enum PTBDetailCellStyle {
    case TextView, TextField, Switch
    var cellIdentifier: String {
        switch self {
        case TextView:
            return "TextViewCell"
        case TextField:
            return "TextFieldCell"
        case Switch:
            return "SwitchCell"
        }
    }
}

/**
The PTBDetailCell protocol specifies the requirements for a PTBDetailController's table view cell.
*/
@objc protocol PTBDetailCell {
    var columnName: String! { get set }
    var name: String! { get set }
    
    func setValue(value: AnyObject)
    func getValue() -> AnyObject
}
