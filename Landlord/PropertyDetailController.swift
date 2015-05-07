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

        self.appendCell(name: "Street", style: .TextField, forColumnName: "streetAddress", toSection: "Address")
        self.appendCell(name: "City", style: .TextField, forColumnName: "city", toSection: "Address")
        self.appendCell(name: "Content", style: .TextView, forColumnName: "note", toSection: "Note")
        self.appendCell(name: "Has a garage", style: .Switch, forColumnName: "hasGarage", toSection: "Additional")
    }
}
