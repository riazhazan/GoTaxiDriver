//
//  GooglePlacesResponse.swift
//  GoTaxiDriver
//
//  Created by Riaz on 29/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import Foundation
import ObjectMapper

class GooglePlacesResponse: Mappable {
    var routes: [Route]?
    var status: String?
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        routes <- map["routes"]
        status <- map["status"]
    }
}

class Route: Mappable {
    var legs: [Leg]?
    var overviewPolylinePoints: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        legs <- map["legs"]
        overviewPolylinePoints <- map["overview_polyline.points"]
    }
}

class Leg: Mappable {
    var distance: String?
    var duration: String?
    var startLocationLat: Double?
    var startLocationLng: Double?
    var endLocationLat: Double?
    var endLocationLng: Double?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        distance <- map["distance.text"]
        duration <- map["duration.text"]
        startLocationLat <- map["start_location.lat"]
        startLocationLng <- map["start_location.lng"]
        endLocationLat <- map["end_location.lat"]
        endLocationLng <- map["end_location.lng"]
    }
}

