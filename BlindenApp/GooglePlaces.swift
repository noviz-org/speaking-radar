//
//  GooglePlaces.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 24.02.18.
//  Copyright Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation

class GooglePlaces
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
        let response: GooglePlacesResponse
        do
        {
            if let escapeData = data
            {
                response = try JSONDecoder().decode(GooglePlacesResponse.self, from: escapeData)
                return response
            }
            else
            {
                print("data is nil");
                return nil;
            }
        }
        catch
        {
            print("Parsing Error: "+error.localizedDescription)
            return nil
        }
    }}




struct GooglePlacesResponse: Codable
{
    var html_attributions: [String]
    var next_page_token: String
    
    var results: [GooglePlacesResult]
    
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

struct GooglePlacesGeometry: Codable
{
    var location: CoordinateLocation
    var viewport: GooglePlacesViewport
}

struct GooglePlacesViewport: Codable
{
    var northeast: CoordinateLocation
    var southwest: CoordinateLocation
}

struct GooglePlacesOpeningHours: Codable
{
    var open_now: Bool
}
