//
//  Ride.swift
//  GoTaxiDriver
//
//  Created by Riaz on 28/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import ObjectMapper

class StopRide: Mappable {
    var statusCode: Int?
    var statusMessage: String?
    var amount: Int?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.statusCode         <- map["StatusCode"]
        self.statusMessage       <- map["StatusMessage"]
        self.amount             <- map["Amount"]
    }
}

