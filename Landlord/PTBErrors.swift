//
//  PTBErrors.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 01.12.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import Foundation

let PTBErrorDomain: String = "com.bprzemyslaw.PTB.ErrorDomain"

enum PTBErrorCode: Int {
    case BlankUsernameError = 1
    case BlankPasswordError = 2
}