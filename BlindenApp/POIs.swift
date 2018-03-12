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
    
    static func getPois(location: WorldLocation) -> [GooglePlacesResult]
    {
        print("getting POI data")
        
        var array: [GooglePlacesResult] = []
        
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
                    
                    let response: GooglePlacesResponse? = GooglePlaces.parseData(data: data!)
                    
                    if let safe_response: GooglePlacesResponse = response
                    {
                        for result in safe_response.results
                        {
                            array.append(result)
                        }
                    }
                    else
                    {
                        print("Parsing failed")
                    }
                }
                
            }).resume()
        }
        return array
    }
    
    
    static func makePOIsFromGooglePlaces(currentLocation: WorldLocation, currentOrientation: Double, googlePlaces: [GooglePlacesResult]) //-> [PointOfInterest]
    {
        
    }
    
}


class WorldLocation
{
    var lat: Double
    var lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
