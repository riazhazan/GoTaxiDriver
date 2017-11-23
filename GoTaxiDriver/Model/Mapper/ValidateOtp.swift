//
//  ValidateOtp.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//


import Foundation
import ObjectMapper

class ValidateOtp: Mappable {
    var statusCode: Int?
    var statusMessage: String?
    var isExistingUser: Bool?
    var token: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.statusCode         <- map["StatusCode"]
        self.statusMessage      <- map["StatusMessage"]
        self.isExistingUser     <- map["IsExistingUser"]
        self.token              <- map["Token"]
        
    }
}

class ValidateUserName: Mappable {
    var statusCode: Int?
    var statusMessage: String?
    var isAvailable: Bool?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.statusCode         <- map["StatusCode"]
        self.statusMessage      <- map["StatusMessage"]
        self.isAvailable        <- map["IsAvailable"]
    }
}
