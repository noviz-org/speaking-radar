//
//  poi.swift
//  BlindenAppTest
//
//  Created by Lukas Reitemeier on 22.10.17.
//  Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation


class POIs
{    
    // Takes in a GooglePlaces Array and returns a PointOfInterest Array
    static func makePOIsFromGooglePlaces(currentLocation: Location, googlePlaces: [GooglePlacesResult]) -> [PointOfInterest]
    {
        var pois: [PointOfInterest] = []
        for place in googlePlaces
        {
            pois.append(PointOfInterest(observerLocation: currentLocation, googlePlace: place))
        }
        return pois
    }
    
}

