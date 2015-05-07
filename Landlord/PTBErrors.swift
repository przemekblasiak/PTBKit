//
//  PTBErrors.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 01.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import Foundation

/// The error domain for PTBKit errors.
let PTBErrorDomain: String = "com.bprzemyslaw.PTBKit.ErrorDomain"

/// NSError codes in the PTBKit error domain.
enum PTBErrorCode: Int {
    
    /// Blank username.
    case BlankUsernameError = 1
    
    /// Blank password.
    case BlankPasswordError = 2
    
    var description: String {
        switch self {
        case .BlankUsernameError:
            return "Provide username"
        case .BlankPasswordError:
            return "Provide password"
        }
    }
}