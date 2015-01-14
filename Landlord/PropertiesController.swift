//
//  PropertiesController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 02.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

class PropertiesController: PTBMasterController, UISplitViewControllerDelegate {
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadObjects(className: "Property", titleColumnName: "streetAddress")
    }
}
