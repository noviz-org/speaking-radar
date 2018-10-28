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
    static func fetchAndReturnPointsOfInterest(location: CoordinateLocation, currentOrientation: Double)
    {
        // Get and output
        print("lat: "+String(location.lat)+", lng: "+String(location.lng)+", heading: \(currentOrientation)")
        
        // Zürich: CoordinateLocation(lat: 47.366696, lng: 8.545235)
        
        Speech.startSearchPhrase()
        
        
        // Start fetching the Google Places.
        POIs.getGooglePlaces(location: location, currentOrientation: currentOrientation);
    }
    
    static func gotGooglePlaces(places: [GooglePlacesResult], location: CoordinateLocation, currentOrientation: Double)
    {
        print("current orientation: "+String(currentOrientation))
        
        let points = sortPOIsForAngle(pois: POIs.makePOIsFromGooglePlaces(currentLocation: location, googlePlaces: places))
        
        let slicedPoints = getPOIsInPizzaSlice(allPOIsSorted: points, currentOrientation: currentOrientation, sliceAngle: 45)
        
        let sortedPoints = sortPOIsForDistance(pois: slicedPoints)

        ViewController.outputPointsOfInterest(pointsOfInterest: sortedPoints)
    }
    
    static func sortPOIsForAngle(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.angleInDegrees < $1.angleInDegrees })
    }
    static func sortPOIsForDistance(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.distanceInMeters < $1.distanceInMeters })
    }
    
    static func getPOIsInPizzaSlice(allPOIsSorted: [PointOfInterest], currentOrientation: Double, sliceAngle: Double) -> [PointOfInterest] // returned array might be empty
    {
        // return all POIs in the pizza slice
        var firstElementIndex: Int? = nil
        var lastElementIndex: Int? = nil
        
        // find first element index
        for i in stride(from: 0, through: allPOIsSorted.count-1, by: 1) {
            if allPOIsSorted[i].angleInDegrees > currentOrientation-sliceAngle/2
            {
                firstElementIndex = i
                break
            }
        }
        
        // find last element index
        for i in stride(from: allPOIsSorted.count-1, through: 0, by: -1) {
            if allPOIsSorted[i].angleInDegrees < currentOrientation+sliceAngle/2
            {
                lastElementIndex = i
                break
            }
        }
        
        // find elements
        
        var elements: [PointOfInterest] = []
        
        if firstElementIndex != nil && lastElementIndex != nil
        {
            
            for i in stride(from: firstElementIndex!, through: lastElementIndex!, by: 1)
            {
                elements.append(allPOIsSorted[i])
            }
        }
        else
        {
            // No elements found in this slice
            print("No elements found between \(currentOrientation-sliceAngle/2) and \(currentOrientation+sliceAngle/2)")
        }
        
        return elements
    }
    
}


