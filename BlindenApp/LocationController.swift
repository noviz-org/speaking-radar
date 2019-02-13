//
//  LocationController.swift
//  Speaking Radar
//
//  Created by Lukas Bühler on 06.02.19.
//  Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate
{
    // The static LocationManager instance
    let locManager = CLLocationManager()
    
    override init()
    {
        super.init()
        
        locManager.delegate = self
        
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        locManager.startUpdatingHeading()
    }
    
    // locationCoordinates declaration
    private var _locationCoordinates: CLLocation? = nil
    var locationCoordinates: CLLocation?
    {
        get
        {
            return _locationCoordinates
        }
    }
    // Stores callbacks to call when updating the locationCoordinates
    private var locationCoordinatesUpdateCallbacks: [(CLLocation?) -> Void] = []
    func addLocationCoordinatesUpdateCallback(callback: @escaping (CLLocation?) -> Void)
    {
        locationCoordinatesUpdateCallbacks.append(callback);
    }
    
    // locationHeading declaration
    private var _locationHeading: Double? = 0
    var locationHeading: Double?
    {
        get
        {
            return _locationHeading
        }
    }
    // Stores callbacks to call when updating the locationHeading
    private var locationHeadingUpdateCallbacks: [(Double?) -> Void] = []
    func addLocationHeadingUpdateCallback(callback: @escaping (Double?) -> Void)
    {
        locationHeadingUpdateCallbacks.append(callback);
    }
    
    // Those functions update the actual values with the information of the sensors
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // Store the value
        _locationCoordinates = locations[0]
        
        // Call the callback
        for callback in locationCoordinatesUpdateCallbacks
        {
            callback(_locationCoordinates)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading)
    {
        //compassLabel.text = String("Angle: \(heading.trueHeading)");
        
        // Store the value
        _locationHeading = heading.magneticHeading
        
        // Call the callbacks
        for callback in locationHeadingUpdateCallbacks
        {
            callback(_locationHeading)
        }
    }
}
