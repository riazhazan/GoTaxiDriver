//
//  Constants.swift
//  GoTaxi
//
//  Created by Riaz on 21/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

struct Constants {
    
    #if DEBUG
    static let k_ServerURL                = ""
    #else
    static let k_ServerURL              = ""
    #endif
    
    static let isUserLoggedIn   = "isUserLoggedIn"
    static let accessToken      = "accessToken"

    static let validateNumber = "validate/number"
    static let validateOtp = "validate/otp"
}

