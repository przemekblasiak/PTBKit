//
//  StringExtenstion.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 07.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import Foundation

extension String {
    
    func isValidUsername(errorPointer: NSErrorPointer?) -> Bool {
        
        // Check if empty
        if self.isEmpty {
            if errorPointer != nil {
                let userInfo: NSDictionary = [NSLocalizedDescriptionKey: "Brakuje nazwy użytkownika"]
                errorPointer?.memory = NSError(domain: PTBErrorDomain, code: PTBErrorCode.BlankUsernameError.rawValue, userInfo: userInfo)
            }
            return false
        }
        
        return true
    }
    
    func isValidPassword(errorPointer: NSErrorPointer?) -> Bool {
        
        // Check if empty
        if self.isEmpty {
            if errorPointer != nil {
                let userInfo: NSDictionary = [NSLocalizedDescriptionKey: "Brakuje hasła"]
                errorPointer?.memory = NSError(domain: PTBErrorDomain, code: PTBErrorCode.BlankPasswordError.rawValue, userInfo: userInfo)
            }
            return false
        }
        
        return true
    }
}