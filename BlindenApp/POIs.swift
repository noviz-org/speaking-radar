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
    
    static func getGooglePlaces(location: CoordinateLocation, currentOrientation: Double)
    {
        if let url = GooglePlaces.getRequestUrl(lat: location.lat, lng: location.lng, radius: 500)
        {
            // Handle the recieved data from the google API
            
            callGoogleAPI(url: url, callback: {(data: Data?) -> Void in
                parsePlacesAndFetchMoreRecursively(newData: data, placesArray: [], doneCallback: {(places: [GooglePlacesResult]) -> Void in
                    
                    print("Found "+String(places.count)+" places.")
                    //print(places);
                    
                    // Calls this when we are done
                    Controller.gotGooglePlaces(places: places, location: location, currentOrientation: currentOrientation);
                })
            })
        }
    }
    
    static func callGoogleAPI(url: URL, callback: @escaping (_ data: Data?) -> Void) -> Void
    {
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            let status = (response as? HTTPURLResponse)!.statusCode;
            if(status != 200)
            {
                // Houston we have a problem
                print("Recieved an Error with status "+String(status)+" from the Google Places API");
                print(error!.localizedDescription);
                
                // TODO: Further error handling: out of requests and so on.
            }
            else
            {
                callback(data);
            }
            
        }).resume()
    }
    
    static func parsePlacesAndFetchMoreRecursively(newData: Data?, placesArray: [GooglePlacesResult], doneCallback: @escaping (_ places: [GooglePlacesResult]) -> Void)
    {
        let response: GooglePlacesResponse? = GooglePlaces.parseData(data: newData) // TODO
        
        if let safe_response: GooglePlacesResponse = response
        {
            var array: [GooglePlacesResult] = placesArray;
            array.append(contentsOf: safe_response.results)
            
            let nextPage = safe_response.next_page_token;
            print("nextPage: "+nextPage)
            if(!nextPage.isEmpty)
            {
                // There are more pages
                let url = GooglePlaces.getPageTokenRequestUrl(token: nextPage)!;
                
                print("next Request URL: "+url.absoluteString);
                
                callGoogleAPI(url: url) { (data: Data?) -> Void in
                    parsePlacesAndFetchMoreRecursively(newData: data, placesArray: array, doneCallback: doneCallback)
                }
            }
            else
            {
                // No more pages!
                doneCallback(placesArray);
            }
        }
        else
        {
            print("Parsing failed")
            
            // show me what you got
            doneCallback(placesArray);
        }
    }
    
    
    static func makePOIsFromGooglePlaces(currentLocation: CoordinateLocation, googlePlaces: [GooglePlacesResult]) -> [PointOfInterest]
    {
        var pois: [PointOfInterest] = []
        for place in googlePlaces
        {
            // Calculate distance between coordinates
            let dist = CoordinateLocation.calculateDistanceBetweenPointsInMeters(loc1: currentLocation, loc2: place.geometry.location)
            
            // Calculate the angle
            let angle = CoordinateLocation.claculateAngleToLongitudeInDegrees(currentLocation: currentLocation, pointLocation: place.geometry.location) // TODO
            
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
        let earthRadiusKm = 6371 // km
    
        let dLat = (loc2.lat-loc1.lat)*(Double.pi/180)
        let dLon = (loc2.lng-loc1.lng)*(Double.pi/180)
    
        let lat1 = (loc1.lat)*(Double.pi/180)
        let lat2 = (loc2.lat)*(Double.pi/180)
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        return Double(earthRadiusKm) * c * Double(1000)
    }
    
    static func claculateAngleToLongitudeInDegrees(currentLocation: CoordinateLocation, pointLocation: CoordinateLocation) -> Double
    {
        let vector_x = pointLocation.lng - currentLocation.lng
        let vector_y = pointLocation.lat - currentLocation.lat
        
        let angle_rad = atan2(vector_y, vector_x) - atan2(1, 0)
        return ((angle_rad * (-180/Double.pi)) + 360).truncatingRemainder(dividingBy: 360)
    }
}
