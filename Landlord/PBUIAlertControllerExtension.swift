
//
//  PBUIAlertControllerExtension.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 23.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    convenience init(errorMessage: String?) {
        self.init(title: "Ups", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        self.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
    }
}