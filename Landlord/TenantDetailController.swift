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

        self.addCell(style: .TextField, sectionName: "Nazwa", columnName: "name")
        self.addCell(style: .TextView, sectionName: "Notatka", columnName: "note")
    }
}