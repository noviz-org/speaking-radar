//
//  PointOfInterest.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 11.03.18.
//  Copyright Copyright © 2019 NOVIZ. All rights reserved.
//

/**
    This class defines the Point of Interest.
    The Point of Interest is an Object with a Location relative to the observer.
    It has a name, a type and a location.
    It's position is given with the distance to the observer and the heading relative to the geographical north.
*/

import Foundation

class PointOfInterest
{
    var title: String
    var type: PointOfInterestType?
    var distanceInMeters: Int
    var angleInDegrees: Double
    
    init(title: String, distanceInMeters: Int, angleInDegrees: Double) {
        self.title = title
        self.distanceInMeters = distanceInMeters
        self.angleInDegrees = angleInDegrees
    }
    init(observerLocation: Location, googlePlace: GooglePlacesResult)
    {
        self.title = googlePlace.name
        
        self.distanceInMeters = Int(Location.calculateDistanceBetweenPointsInMeters(loc1: observerLocation, loc2: googlePlace.geometry.location).rounded())
        
        self.angleInDegrees = Location.claculateAngleToLongitudeInDegrees(currentLocation: observerLocation, pointLocation: googlePlace.geometry.location)
        
        if let types = googlePlace.types
        {
            if (types.contains("restaurant"))
            {
                self.type = PointOfInterestType.restaurant
            }
            else if (types.contains("store"))
            {
                self.type = PointOfInterestType.store
            }
        }
    }
}

extension PointOfInterest: CustomStringConvertible {
    var description: String {
        return "'\(title)', \(distanceInMeters)m, \(angleInDegrees) degrees"
    }
}

enum PointOfInterestType
{
    case restaurant, store
}
