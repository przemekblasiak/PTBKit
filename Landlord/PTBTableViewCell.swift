//
//  PTBTableViewCell.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 19.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

enum PTBTableViewCellStyle {
    case TextView
    case TextField
    case Switch
}

// TODO: Protocol/Interface?
class PTBTableViewCell: UITableViewCell {

// MARK: Properties
    var columnName: String!
    
    // TODO: Refactor, maybe computed property or sth
    func setValue(value: AnyObject) {}
    func getValue() -> AnyObject { return 0 }
    
    func setName(name: String) {}
}
