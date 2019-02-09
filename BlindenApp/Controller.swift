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
    let viewController: ViewController
    let locationController: LocationController
    
    var googlePlaces: [GooglePlacesResult] = []
    var pointsOfInterest: [PointOfInterest] = []

    init(vc: ViewController)
    {
        viewController = vc
        locationController = LocationController() // Initialise the LocationController
        
        locationController.addLocationHeadingUpdateCallback(callback: { (_heading: Double?) in
            if let heading: Double = _heading
            {
                self.viewController.updateOrientationArrow(heading: heading)
            }
        })
        locationController.addLocationHeadingUpdateCallback(callback: { (_heading: Double?) in
            if let heading: Double = _heading
            {
                self.viewController.updateRadarHeading(heading: heading)
            }
        })
        
        locationController.addLocationCoordinatesUpdateCallback(callback: { (_location: CLLocation?) in
            
            if let location = _location
            {
                self.pointsOfInterest = POIs.makePOIsFromGooglePlaces(currentLocation: Location(loc: location), googlePlaces: self.googlePlaces)
                self.viewController.updateRadarPoints(pois: self.pointsOfInterest)
            }
        })
    }
    
    func loadGooglePlaces()
    {
        Speech.speakLoadingPointsOfInterest()
        
        // Saves the google Places in the local variable
        if let cllocation: CLLocation = self.locationController.locationCoordinates
        {
            // Call the Google Places API
            let radius = 500
            GooglePlacesAPI.getGooglePlaces(location: Location(loc: cllocation), radius: radius, callback:
                {
                    (places) in
                    // We recieved the GooglePlaces
                    
                    self.googlePlaces = places
                    
                    // Also make the points of interest
                    if let cllocation: CLLocation = self.locationController.locationCoordinates
                    {
                        // We do this again to make sure to use the updated location
                        self.pointsOfInterest = POIs.makePOIsFromGooglePlaces(currentLocation: Location(loc: cllocation), googlePlaces: self.googlePlaces)
                        
                        self.viewController.updateRadarPoints(pois: self.pointsOfInterest)
                        Speech.speakDoneLoading(poi_count: self.pointsOfInterest.count, radius: radius)
                    }
            })
        }
        else
        {
            // We cannot access the location
            print("ERROR: Cannot resolve location")
            
            // Tell the user that we can't access the location.
            // Speech...
        }
    }
    
    
    func sortPOIsForAngle(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.angleInDegrees < $1.angleInDegrees })
    }
    func sortPOIsForDistance(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.distanceInMeters < $1.distanceInMeters })
    }
    
    func getPOIsInPizzaSlice(allPOIsSorted: [PointOfInterest], sliceAngle: Double) -> [PointOfInterest] // returned array might be empty
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


