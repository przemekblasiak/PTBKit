//
//  TenantsController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 24.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class TenantsController: PTBMasterController {
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populate(className: "Tenant", columnName: "name") //TODO: Lepsza nazwa funkcji
    }
}