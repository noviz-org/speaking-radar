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
    static var url: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    
    static func getRequestUrl(lat: Double, lng: Double, radius: Int) -> URL?
    {
        return URL(string: url+"key="+getKeyFromFile(fileName: "GooglePlacesKey")+"&location="+String(lat)+","+String(lng)+"&radius="+String(radius))
    }
    static func getPageTokenRequestUrl(token: String) -> URL?
    {
        let urlString = url+"key="+getKeyFromFile(fileName: "GooglePlacesKey")+"&pagetoken="+token;
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
