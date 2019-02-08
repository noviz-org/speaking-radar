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
    static func getPointsOfInterestAsync(location: Location, radius: Int, callback: @escaping ([PointOfInterest]) -> Void)
    {
        // Call the Google Places API
        GooglePlacesAPI.getGooglePlaces(location: location, radius: radius, callback:
        {
            (places) in
            // We recieved the GooglePlaces
            
            // Call the callback with the new fetched points
            callback(makePOIsFromGooglePlaces(currentLocation: location, googlePlaces: GooglePlacesAPI.filterOnlyPlaceOfInterestGooglePlaces(places: places)))
        })
    }
    
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

