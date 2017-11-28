//
//  LocationService.swift
//  GoTaxiDriver
//
//  Created by Riaz on 24/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import CoreLocation

public class LocationService: NSObject, CLLocationManagerDelegate{
    
    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var updateLocationDelegate: UpdateLocationDelegate?
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.activityType = .automotiveNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = false
        
        super.init()
        locationManager.delegate = self
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last{
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
            updateLocationDelegate?.didUpdateLocation(location: newLocation)
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}


protocol UpdateLocationDelegate {
    func didUpdateLocation(location: CLLocation)
}
