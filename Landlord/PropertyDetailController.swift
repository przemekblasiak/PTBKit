//
//  PropertyDetailController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 28.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit

class PropertyDetailController: PTBDetailController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCell(style: .TextField, sectionName: "Adres", cellName:"Ulica", columnName: "streetAddress")
        self.addCell(style: .TextField, sectionName: "Adres", cellName:"Miasto", columnName: "city")
        self.addCell(style: .TextView, sectionName: "Notatka", cellName:"Treść", columnName: "note")
    }

}
