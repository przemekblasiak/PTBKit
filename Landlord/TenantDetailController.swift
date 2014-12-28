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

        self.addCell(style: .TextField, sectionName: "Nazwa", cellName:"Imię i nazwisko", columnName: "name")
        self.addCell(style: .TextView, sectionName: "Notatka", cellName:"Treść notatki", columnName: "note")
        self.addCell(style: .Switch, sectionName: "Dodatkowe", cellName:"Media", columnName: "paysForMedia")
    }
}