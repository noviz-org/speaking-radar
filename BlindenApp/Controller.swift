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
    var sectionAngle: Double = 45.0

    init(vc: ViewController)
    {
        viewController = vc
        locationController = LocationController() // Initialise the LocationController
        
        // Set the section angle
        self.viewController.setRadarSectionAngle(angle: self.sectionAngle)
        
        
        // Add the callbacks to call when updating the location coordinates and heading
        
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
    
    func speakSection()
    {
        // Get section points of interest
        var pois: [PointOfInterest] = self.getPointsOfInterestInSection(pointsOfInterest: self.pointsOfInterest)
        
        // Sort them by distance (closest first)
        pois = self.sortPOIsForDistance(pois: pois)
        
        // Speak them
        Speech.speakPointsOfInterestSection(radius_sorted_points: pois)
    }
    
    func navigateToPointOfInterest()
    {
        // 1. We look at what was last said and repeat it to confirm
        // 2. We let the user confirm by swiping up again. Abort, by swiping down and select the previous or next by swiping left and right
        // 3. On confirmation we open the location in Maps
        
        AppleMaps.openInMaps(place: googlePlaces[0])
    }
    
    
    func sortPOIsForAngle(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.angleInDegrees < $1.angleInDegrees })
    }
    func sortPOIsForDistance(pois: [PointOfInterest]) -> [PointOfInterest]
    {
        return pois.sorted(by: { $0.distanceInMeters < $1.distanceInMeters })
    }
    
    func getPointsOfInterestInSection(pointsOfInterest: [PointOfInterest]) -> [PointOfInterest] // returned array might be empty
    {
        let points = sortPOIsForAngle(pois: pointsOfInterest)
        
        if let heading: Double = locationController.locationHeading
        {
            // return all POIs in the pizza slice
            var firstElementIndex: Int? = nil
            var lastElementIndex: Int? = nil
            
            // find first element index
            for i in stride(from: 0, through: points.count-1, by: 1) {
                if points[i].angleInDegrees > heading-self.sectionAngle/2
                {
                    firstElementIndex = i
                    break
                }
            }
            
            // find last element index
            for i in stride(from: points.count-1, through: 0, by: -1) {
                if points[i].angleInDegrees < heading+self.sectionAngle/2
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
                    elements.append(points[i])
                }
            }
            else
            {
                // No elements found in this slice
                print("No elements found between \(heading-sectionAngle/2) and \(heading+sectionAngle/2)")
            }
            
            return elements
        }
        else
        {
            print("Couldn't unwrap heading")
            return []
        }
    }
}


