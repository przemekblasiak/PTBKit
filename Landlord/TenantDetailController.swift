//
//  TenantDetailController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 09.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

class TenantDetailController: PTBDetailController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appendCell(name: "Name", style: .TextField, forColumnName: "name", toSection: "Personal")
        self.appendCell(name: "Content", style: .TextView, forColumnName: "note", toSection: "Note")
        self.appendCell(name: "Student", style: .Switch, forColumnName: "isStudent", toSection: "Additional")
        self.appendCell(name: "Has a pet", style: .Switch, forColumnName: "hasPet", toSection: "Additional")
    }
}