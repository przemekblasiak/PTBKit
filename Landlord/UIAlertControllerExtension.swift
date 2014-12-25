
//
//  UIAlertControllerExtension.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 23.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    enum UIAlertControllerType {
        case Error
        case Confirm
    }
    
    convenience init(type: UIAlertControllerType, message: String?) {
        self.init(title: "", message: message, preferredStyle: .Alert)
        
        // Do type dependent setup
        switch type {
        case .Confirm:
            self.title = "Potwierdzenie"
        case .Error:
            self.title = "Ups"
            self.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        }
    }
    
    convenience init(type: UIAlertControllerType, error: NSError) {
        var codeDescription: String?
        
        switch error.domain {
        case "Parse":
            switch error.code {
            case 100:
                codeDescription = "Brakuje połączenia z internetem."
            case 101:
                codeDescription = "Podana nazwa użytkownika lub hasło są niepoprawne"
            case 202:
                codeDescription = "Podana nazwa użytkownika jest już zajęta."
            default:
                codeDescription = String(error.localizedDescription)
            }
        default:
            
            // For my domain and other
            codeDescription = String(error.localizedDescription)
        }
        
        self.init(type: .Error, message: codeDescription)
    }
}