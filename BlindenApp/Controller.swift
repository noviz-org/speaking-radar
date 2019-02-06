//
//  Controller.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 14.03.18.
//  Copyright ©Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation
import CoreLocation

class Controller
{
    var pointsOfInterest: [PointOfInterest] = []
    var googlePlaces: [GooglePlacesResult] = []
    
    static func loadPointsOfInterest(locationController: LocationController)
    {
        if let cllocation: CLLocation = locationController.locationCoordinates
        {
            // We can access the location
            
            // Tell the user that we are loading
            Speech.startSearchPhrase()
            
            POIs.getGooglePlaces(location: Location(loc: cllocation))
        }
        else
        {
            // We cannot access the location
            print("ERROR: Cannot resolve location")
            
            // Tell the user that we can't access the location.
            // Speech...
        }

    }
    
    static func gotGooglePlaces(places: [GooglePlacesResult], location: Location)
    {
        let points = sortPOIsForAngle(pois: POIs.makePOIsFromGooglePlaces(currentLocation: location, googlePlaces: places))
        
        print(points)
        
        let slicedPoints = getPOIsInPizzaSlice(allPOIsSorted: points, sliceAngle: 45)
        
        let sortedPoints = sortPOIsForDistance(pois: slicedPoints)

        ViewController.updateView(pointsOfInterest: sortedPoints)
    }
    
    static func sortPOIsForAngle(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.angleInDegrees < $1.angleInDegrees })
    }
    static func sortPOIsForDistance(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.distanceInMeters < $1.distanceInMeters })
    }
    
    static func getPOIsInPizzaSlice(allPOIsSorted: [PointOfInterest], sliceAngle: Double) -> [PointOfInterest] // returned array might be empty
    {
        let currentOrientation: Double = 180//ViewController.getHeading()
        
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


