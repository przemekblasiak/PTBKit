//
//  StringExtenstion.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 07.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

/**
The file contains an extension of the String class
*/

import Foundation

extension String {
    
    func isValidUsername(errorPointer: NSErrorPointer?) -> Bool {
        if self.isEmpty {
            if errorPointer != nil {
                let userInfo: NSDictionary = [NSLocalizedDescriptionKey: PTBErrorCode.BlankUsernameError.description]
                errorPointer?.memory = NSError(domain: PTBErrorDomain, code: PTBErrorCode.BlankUsernameError.rawValue, userInfo: userInfo)
            }
            return false
        }
        return true
    }
    
    func isValidPassword(errorPointer: NSErrorPointer?) -> Bool {
        if self.isEmpty {
            if errorPointer != nil {
                let userInfo: NSDictionary = [NSLocalizedDescriptionKey: PTBErrorCode.BlankPasswordError.description]
                errorPointer?.memory = NSError(domain: PTBErrorDomain, code: PTBErrorCode.BlankPasswordError.rawValue, userInfo: userInfo)
            }
            return false
        }
        return true
    }
}