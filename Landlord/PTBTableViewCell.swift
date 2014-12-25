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

class PTBTableViewCell: UITableViewCell {

    // MARK: Properties
    var columnName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.columnName != nil {
            self.setText(self.columnName)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(text: String) {
    }

}
