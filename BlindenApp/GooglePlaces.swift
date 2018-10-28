//
//  GooglePlaces.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 24.02.18.
//  Copyright © 2018 Lukas Reitemeier. All rights reserved.
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
        return URL(string: url+"key="+getKeyFromFile(fileName: "GooglePlacesKey")+"&pagetoken="+token);
    }
    
    static func getKeyFromFile(fileName: String) -> String
    {
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        
        do {
            let str = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            return str.substring(to: str.index(of: "\n")!) // This is dangerous TODO fix it.
        }
        catch
        {
            print("Error while reading key from file")
            return ""
        }
    }
    
    static func parseData(data: Data) -> GooglePlacesResponse?
    {
        let response: GooglePlacesResponse
        do
        {
            response = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
        }
        catch _
        {
            return nil
        }
        return response
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
    var icon: String
    var id: String
    var name: String
    var place_id: String
    var reference: String
    var scope: String
    var types: [String]
    var vicinity: String
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
