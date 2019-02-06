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
    static func getPointsOfInterestAsync(location: Location, radius: Int, callback: ([PointOfInterest]) -> Void)
    {
        // Call the Google Places API
        GooglePlacesAPI.getGooglePlaces(location: location, radius: radius, callback:
        {
            (places) in
            
            print(places)
            
            /*
            parsePlacesAndFetchMoreRecursively(newData: data, placesArray: [], doneCallback: {(places: [GooglePlacesResult]) -> Void in
                
                print("Found "+String(places.count)+" places.")
                //print(places);
                
                // Calls this when we are done
                Controller.gotGooglePlaces(places: places, location: location)
            })
            */
        })
    }
    
    
    
    
    
    static func makePOIsFromGooglePlaces(currentLocation: Location, googlePlaces: [GooglePlacesResult]) -> [PointOfInterest]
    {
        var pois: [PointOfInterest] = []
        for place in googlePlaces
        {
            // Calculate distance between coordinates
            let dist = Location.calculateDistanceBetweenPointsInMeters(loc1: currentLocation, loc2: place.geometry.location)
            
            // Calculate the angle
            let angle = Location.claculateAngleToLongitudeInDegrees(currentLocation: currentLocation, pointLocation: place.geometry.location) // TODO?
            
            // Set stuff
            pois.append(PointOfInterest(title: place.name, distanceInMeters: Int(dist.rounded()), angleInDegrees: angle))
        }
        return pois
    }
    
}

