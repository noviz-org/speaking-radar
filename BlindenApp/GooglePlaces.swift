//
//  GooglePlaces.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 24.02.18.
//  Copyright Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation

class GooglePlacesAPI
{
    static var api_url: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    
    
    static func getGooglePlaces(location: Location, radius: Int, callback: @escaping ([GooglePlacesResult]) -> Void)
    {
        if let url: URL = GooglePlacesAPI.getRequestUrl(lat: location.lat, lng: location.lng, radius: radius)
        {
            GooglePlacesAPI.call(url: url, callback:
            {
                (data) in
                handleDataAndFetchMore(newData: data, googlePlaces: [], callback: callback)
            })
        }
    }
    
    
    private static func call(url: URL, callback: @escaping (Data?) -> Void) -> Void
    {
        // Calls the API and returns the recieved Data through a callback
        
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            let httpCode = (response as? HTTPURLResponse)!.statusCode;
            
            if(httpCode == 200)
            {
                callback(data);
            }
            else
            {
                // Houston we have a problem
                print("Got an HTTP Error "+String(httpCode)+" from the Google Places API");
                print("Error: "+error!.localizedDescription);
            }
            
        }).resume()
        
    }
    
    static func getRequestUrl(lat: Double, lng: Double, radius: Int) -> URL?
    {
        return URL(string: api_url+"key="+getKeyFromFile(fileName: "GooglePlacesKey")+"&location="+String(lat)+","+String(lng)+"&radius="+String(radius))
    }
    static func getPageTokenRequestUrl(token: String) -> URL?
    {
        let urlString = api_url+"key="+getKeyFromFile(fileName: "GooglePlacesKey")+"&pagetoken="+token;
        return URL(string: urlString);
    }
    
    static func getKeyFromFile(fileName: String) -> String
    {
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        
        do {
            let str = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            return str.trimmingCharacters(in: .whitespacesAndNewlines) // Removes leading and trailing whitespaces
        }
        catch
        {
            print("Error while reading key from file")
            return ""
        }
    }
    
    static func handleDataAndFetchMore(newData: Data?, googlePlaces: [GooglePlacesResult], callback: @escaping ([GooglePlacesResult]) -> Void)
    {
        if let response: GooglePlacesResponse = GooglePlacesAPI.parseData(data: newData)
        {
            var places: [GooglePlacesResult] = googlePlaces
            places.append(contentsOf: response.results)
            
            if let nextPage = response.next_page_token
            {
                // There are more pages
                let url = GooglePlacesAPI.getPageTokenRequestUrl(token: nextPage)!;
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) // creates delay before the next request for the google places api
                {
                    GooglePlacesAPI.call(url: url, callback: { (data: Data?) -> Void in
                        handleDataAndFetchMore(newData: data, googlePlaces: places, callback: callback)
                    })
                }
            }
            else
            {
                // No results
                if(response.status == "OK")
                {
                    // No more pages!
                    callback(places);
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
            callback(googlePlaces);
        }
    }
    
    static func parseData(data: Data?) -> GooglePlacesResponse?
    {
        do
        {
            let response = try JSONDecoder().decode(GooglePlacesResponse.self, from: data!)
            return response
        }
        catch
        {
            print("Parsing Error: "+error.localizedDescription)
            return nil
        }
    }
    
    static func filterOnlyPlaceOfInterestGooglePlaces(places: [GooglePlacesResult]) -> [GooglePlacesResult]
    {
        return places.filter
        {
            if let types = $0.types
            {
                return types.contains("point_of_interest")
            }
            return false
        };
    }
}




struct GooglePlacesResponse: Codable
{
    var html_attributions: [String]
    var next_page_token: String?
    var results: [GooglePlacesResult]
    var status: String
}
extension GooglePlacesResponse: CustomStringConvertible {
    var description: String {
        if(next_page_token != nil)
        {
            return "results=\(results), next_page_token='\(next_page_token!)'"
        }
        else
        {
            return "results=\(results) (No more results)"
        }
    }
}


struct GooglePlacesResult: Codable
{
    var geometry: GooglePlacesGeometry
    var icon: String?
    var id: String
    var name: String
    var opening_hours: GooglePlacesOpeningHours?
    var place_id: String
    var reference: String?
    var scope: String?
    var types: [String]?
    var vicinity: String?
}
extension GooglePlacesResult: CustomStringConvertible {
    var description: String {
        return "'\(name)'"
    }
}


struct GooglePlacesGeometry: Codable
{
    var location: Location
    var viewport: GooglePlacesViewport
}

struct GooglePlacesViewport: Codable
{
    var northeast: Location
    var southwest: Location
}

struct GooglePlacesOpeningHours: Codable
{
    var open_now: Bool
}
