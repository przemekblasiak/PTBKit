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

        self.appendCell(name: "Ulica", style: .TextField, forColumnName: "streetAddress", toSection: "Adres")
        self.appendCell(name: "Miasto", style: .TextField, forColumnName: "city", toSection: "Adres")
        self.appendCell(name: "Treść", style: .TextView, forColumnName: "note", toSection: "Notatka")
        self.appendCell(name: "Posiada garaż", style: .Switch, forColumnName: "hasGarage", toSection: "Dodatkowe")
    }
}
