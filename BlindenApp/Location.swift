//
//  Location.swift
//  Speaking Radar
//
//  Created by Lukas Bühler on 06.02.19.
//  Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation
import CoreLocation;

// This location only defines lat and long, since we don't get more information from the google places api
// The functions are used to calculate important stuff that is used throughout the app.
class Location: Codable
{
    var lat: Double
    var lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
    init(loc: CLLocation)
    {
        lat = loc.coordinate.latitude
        lng = loc.coordinate.longitude
    }
    
    static func calculateDistanceBetweenPointsInMeters(loc1: Location, loc2: Location) -> Double
    {
        let earthRadiusKm = 6371 // km
        
        let dLat = (loc2.lat-loc1.lat)*(Double.pi/180)
        let dLon = (loc2.lng-loc1.lng)*(Double.pi/180)
        
        let lat1 = (loc1.lat)*(Double.pi/180)
        let lat2 = (loc2.lat)*(Double.pi/180)
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        return Double(earthRadiusKm) * c * Double(1000)
    }
    
    static func claculateAngleToLongitudeInDegrees(currentLocation: Location, pointLocation: Location) -> Double
    {
        let vector_x = pointLocation.lng - currentLocation.lng
        let vector_y = pointLocation.lat - currentLocation.lat
        
        let angle_rad = atan2(vector_y, vector_x) - atan2(1, 0)
        return ((angle_rad * (-180/Double.pi)) + 360).truncatingRemainder(dividingBy: 360)
    }
}

