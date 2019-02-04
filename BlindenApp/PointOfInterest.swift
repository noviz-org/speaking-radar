//
//  PointOfInterest.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 11.03.18.
//  Copyright Copyright © 2019 NOVIZ. All rights reserved.
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

extension PointOfInterest: CustomStringConvertible {
    var description: String {
        return "'\(title)', \(distanceInMeters)m, \(angleInDegrees) degrees"
    }
}
