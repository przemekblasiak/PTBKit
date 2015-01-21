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

        self.appendCell(name: "Imię i nazwisko", style: .TextField, forColumnName: "name", toSection: "Dane osobowe")
        self.appendCell(name: "Treść", style: .TextView, forColumnName: "note", toSection: "Notatka")
        self.appendCell(name: "Student", style: .Switch, forColumnName: "isStudent", toSection: "Dodatkowe")
        self.appendCell(name: "Ma zwierzaka", style: .Switch, forColumnName: "hasPet", toSection: "Dodatkowe")
    }
}