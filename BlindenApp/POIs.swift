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
    
    static func getGooglePlaces(location: Location)
    {
        if let url: URL = GooglePlacesAPI.getRequestUrl(lat: location.lat, lng: location.lng, radius: 500)
        {
            // Call the Google API and return the places
            
            callGoogleAPI(url: url, callback: {(data: Data?) -> Void in
                parsePlacesAndFetchMoreRecursively(newData: data, placesArray: [], doneCallback: {(places: [GooglePlacesResult]) -> Void in
                    
                    print("Found "+String(places.count)+" places.")
                    //print(places);
                    
                    // Calls this when we are done
                    Controller.gotGooglePlaces(places: places, location: location)
                })
            })
        }
    }
    
    static func callGoogleAPI(url: URL, callback: @escaping (_ data: Data?) -> Void) -> Void
    {
        
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            let httpStatus = (response as? HTTPURLResponse)!.statusCode;
            
            
            if(httpStatus == 200)
            {
                callback(data);
            }
            else
            {
                // Houston we have a problem
                print("Recieved an Error with status "+String(httpStatus)+" from the Google Places API");
                print(error!.localizedDescription);
            }
            
        }).resume()
    }
    
    static func parsePlacesAndFetchMoreRecursively(newData: Data?, placesArray: [GooglePlacesResult], doneCallback: @escaping (_ places: [GooglePlacesResult]) -> Void)
    {
        if let response: GooglePlacesResponse = GooglePlacesAPI.parseData(data: newData)
        {
            var array: [GooglePlacesResult] = placesArray;
            array.append(contentsOf: response.results)
            
            if let nextPage = response.next_page_token
            {
                //print("nextPage: "+nextPage)
                // There are more pages
                let url = GooglePlacesAPI.getPageTokenRequestUrl(token: nextPage)!;
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) // creates delay before the next request for the google places api
                {
                    callGoogleAPI(url: url, callback: { (data: Data?) -> Void in
                        parsePlacesAndFetchMoreRecursively(newData: data, placesArray: array, doneCallback: doneCallback)
                    })
                }
            }
            else
            {
                // No results
                if(response.status == "OK")
                {
                    // No more pages!
                    doneCallback(array);
                }
                else
                {
                    print("GooglePlacesAPI Response status is '\(response.status)'")
                }
            }
        }
        else
        {
            print("Parsing failed")
            
            // show me what you got
            doneCallback(placesArray);
        }
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

