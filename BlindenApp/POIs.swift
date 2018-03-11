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
    
    static func getPois(location: WorldLocation)
    {
        print("getting POI data")
        
        if let url = GooglePlaces.getRequestUrl(lat: location.lat, lng: location.lng, radius: 500)
        {
            URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                let status = (response as? HTTPURLResponse)!.statusCode;
                if(status != 200)
                {
                    // Houston we have a problem
                    
                }
                else
                {
                    // Do something
                    
                    let response: GooglePlacesResponse? = ViewController.parseData(data: data!)
                    
                    if let safe_response: GooglePlacesResponse = response
                    {
                        for result in safe_response.results
                        {
                            print("Found a result nearby: "+result.name+" "+String(result.geometry.location.lat))
                        }
                    }
                    else
                    {
                        print("OHhh noo")
                    }
                }
                
            }).resume()
        }
    }
    
    
    static func makePOIsFromGooglePlaces(currentLocation: WorldLocation, currentOrientation: Double, googlePlaces: [GooglePlacesResult])
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
