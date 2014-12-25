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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if self.columnName != nil {
            self.textField.text = columnName
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setText(text: String) {
        self.textField.text = text
    }
}
