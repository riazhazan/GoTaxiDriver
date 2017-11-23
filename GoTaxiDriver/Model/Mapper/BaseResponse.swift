//
//  BaseResponse.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
    var statusCode: Int?
    var statusMessage: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.statusCode         <- map["StatusCode"]
        self.statusMessage        <- map["StatusMessage"]
    }
}

