//
//  StringExtenstion.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 07.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import Foundation

extension String {
    
    func isUsernameValid() -> (valid: Bool, errorString: String) {
        
        // Check if not empty
        if self.isEmpty {
            return (false, "Brakuje nazwy użytkownika")
        }
        
        return (true, "")
    }
    
    func isPasswordValid() -> (valid: Bool, errorString: String) {
        
        // Check if not empty
        if self.isEmpty {
            return (false, "Brakuje hasła")
        }
        
        return (true, "")
    }
}