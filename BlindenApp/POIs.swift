//
//  poi.swift
//  BlindenAppTest
//
//  Created by Lukas Reitemeier on 22.10.17.
//  Copyright © 2017 Lukas Reitemeier. All rights reserved.
//

import Foundation


class POIs
{
    
    static func getGooglePlaces(location: CoordinateLocation)
    {
        if let url = GooglePlaces.getRequestUrl(lat: location.lat, lng: location.lng, radius: 500)
        {
            URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                let status = (response as? HTTPURLResponse)!.statusCode;
                if(status != 200)
                {
                    // Houston we have a problem
                    print("Recieved an Error with status "+String(status)+" from the Google Places API");
                    
                    // TODO: Further error handling: out of requests and so on.
                }
                else
                {
                    // Do something
                    var array: [GooglePlacesResult] = []
                    
                    let response: GooglePlacesResponse? = GooglePlaces.parseData(data: data!)
                    
                    if let safe_response: GooglePlacesResponse = response
                    {
                        for result in safe_response.results
                        {
                            array.append(result)
                        }
                        
                        // Then callback to the function
                        Controller.gotGooglePlaces(places: array)
                    }
                    else
                    {
                        print("Parsing failed")
                    }
                }
                
            }).resume()
        }
    }
    
    
    static func makePOIsFromGooglePlaces(currentLocation: CoordinateLocation, currentOrientation: Double, googlePlaces: [GooglePlacesResult]) -> [PointOfInterest]
    {
        var pois: [PointOfInterest] = []
        for place in googlePlaces
        {
            // Calculate distance between coordinates
            let dist = CoordinateLocation.calculateDistanceBetweenPointsInMeters(loc1: currentLocation, loc2: place.geometry.location)
            
            // Calculate the angle
            let angle = Double(0) // TODO
            
            // Set stuff
            pois.append(PointOfInterest(title: place.name, distanceInMeters: Int(dist.rounded()), angleInDegrees: angle))
        }
        return pois
    }
    
}


class CoordinateLocation: Codable
{
    var lat: Double
    var lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
    
    static func calculateDistanceBetweenPointsInMeters(loc1: CoordinateLocation, loc2: CoordinateLocation) -> Double
    {
        // TODO: Check if this is correct...
        
        let earthRadiusKm = 6371 // km
    
        let dLat = (loc2.lat-loc1.lat)*(Double.pi/180)
        let dLon = (loc2.lng-loc1.lng)*(Double.pi/180)
    
        let lat1 = (loc1.lat)*(Double.pi/180)
        let lat2 = (loc2.lat)*(Double.pi/180)
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        return Double(earthRadiusKm) * c * Double(1000);
    }
    
}
