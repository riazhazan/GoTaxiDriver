//
//  NetworkConstants.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

struct Constants {
    
    #if DEBUG
    static let k_ServerURL     = "http://gotaxiapi.codecomb.in/api/"
    #else
    static let k_ServerURL     = "http://gotaxiapi.codecomb.in/api/"
    #endif
    
    //API End points
    static let validateNumber   = "validate/number"
    static let validateOtp      = "validate/otp"
    static let validateUserName = "validate/username?Username=%@"
    static let register         = "Register"
}
