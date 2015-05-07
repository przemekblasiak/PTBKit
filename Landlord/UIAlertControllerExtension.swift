
//
//  UIAlertControllerExtension.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 23.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

/**
The file contains an extension of the UIAlertController class.
*/

import Foundation
import UIKit

extension UIAlertController {
    
    enum UIAlertControllerType {
        case Error
        case Confirm
        var title: String {
            switch self {
            case Error:
                return "Oops"
            case Confirm:
                return "Confirm"
            }
        }
    }
    
    convenience init(type: UIAlertControllerType, message: String?) {
        self.init(title: "", message: message, preferredStyle: .Alert)
        
        self.title = type.title
        if type == .Error {
            self.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        }
    }
    
    convenience init(type: UIAlertControllerType, error: NSError) {
        var codeDescription: String?
        
        // Provide error description, based on the domain
        switch error.domain {
        case "Parse":
            switch error.code {
            case 100:
                codeDescription = "There is no internet connection"
            case 101:
                codeDescription = "Incorrect username or password"
            case 202:
                codeDescription = "The username is already taken"
            default:
                codeDescription = String(error.localizedDescription)
            }
        default:
            codeDescription = String(error.localizedDescription)
        }
        
        // Create an error alert with the description
        self.init(type: .Error, message: codeDescription)
    }
}