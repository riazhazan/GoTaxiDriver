//
//  RegistrationRequest.swift
//  GoTaxi
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class RegistrationRequest {
   
    var userName:String?
    var firstName: String?
    var lastName: String?
    var country:String?
    var countryCode:Int?
    var phone: String?
    var password: String?
    var confirmPassword:String?
    
    func formatInputDictionary() -> Dictionary <String,Any> {
        var dict = [String: Any]()
        dict["FirstName"] = self.firstName ?? ""
        dict["LastName"] = self.lastName ?? ""
        dict["CountryCode"] = self.countryCode ?? ""
        dict["PhoneNumber"] = self.phone ?? ""
        dict["Username"] = self.userName ?? ""
        dict["Password"] = self.password ?? ""
        dict["GcmID"] = 200
        dict["UserType"] = userEntityCode
        dict["DeviceID"] = "kjashd898123jbaksjdh9-0sd-Simulator"
        return dict
    }
}
