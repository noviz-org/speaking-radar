//
//  PointOfInterest.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 11.03.18.
//  Copyright © 2018 Lukas Reitemeier. All rights reserved.
//

import Foundation

class PointOfInterest
{
    var title: String
    var distanceInMeters: Int
    var angleInDegrees: Double
    
    init(title: String, distanceInMeters: Int, angleInDegrees: Double) {
        self.title = title
        self.distanceInMeters = distanceInMeters
        self.angleInDegrees = angleInDegrees
    }
}
