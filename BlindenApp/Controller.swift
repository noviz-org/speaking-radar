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
    }
    
    var pointsOfInterest: [PointOfInterest] = []
    
    func loadPointsOfInterest()
    {
        if let cllocation: CLLocation = self.locationController.locationCoordinates
        {
            // We can access the location
            
            // Tell the user that we are loading
            Speech.startSearchPhrase()
            
            POIs.getPointsOfInterestAsync(location: Location(loc: cllocation), radius: 500, callback:
            {
                (_pointsOfInterest) in
                print(_pointsOfInterest)
                
                self.pointsOfInterest = _pointsOfInterest
                self.viewController.updateRadarPoints(pois: self.pointsOfInterest)
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


