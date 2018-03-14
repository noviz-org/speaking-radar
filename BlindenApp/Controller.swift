//
//  Controller.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 14.03.18.
//  Copyright © 2018 Lukas Reitemeier. All rights reserved.
//

import Foundation

class Controller
{
    static func fetchAndReturnPointsOfInterest(/*location: CoordinateLocation*/)
    {
        // Get and output
        print("Searching for locations")
        
        let location: CoordinateLocation = CoordinateLocation(lat: 47.366696, lng: 8.545235) // should be passed as a parameter
        
        Speech.speakPhrase(text: "Suche nach Orten")
        
        // Start fetching the Google Places.
        POIs.getGooglePlaces(location: location);
    }
    
    static func gotGooglePlaces(places: [GooglePlacesResult])
    {
        let points = POIs.makePOIsFromGooglePlaces(currentLocation: CoordinateLocation(lat: 47.366696, lng: 8.545235), currentOrientation: 0, googlePlaces: places)
        ViewController.outputPointsOfInterest(pointsOfInterest: points)
    }
    
}


