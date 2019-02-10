//
//  AppleMaps.swift
//  Speaking Radar
//
//  Created by Lukas Bühler on 09.02.19.
//  Copyright © 2019 NOVIZ. All rights reserved.
//

import MapKit

class AppleMaps
{
    static func openInMaps(place: GooglePlacesResult)
    {
        let coordinates = CLLocationCoordinate2D(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)
        
        let regionSpan = MKCoordinateRegionMake(coordinates, MKCoordinateSpan(
            latitudeDelta: place.geometry.viewport.northeast.lat - place.geometry.viewport.southwest.lat,
            longitudeDelta: place.geometry.viewport.northeast.lng - place.geometry.viewport.southwest.lng))
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        //regionDistance: CLLocationDistance =
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: options)
    }
}
