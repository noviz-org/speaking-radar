//
//  RadarView.swift
//  Speaking Radar
//
//  Created by Lukas Bühler on 07.02.19.
//  Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation
import UIKit

class RadarView: UIView
{
    var pointsOfInterest: [PointOfInterest] = [];
    var heading: Double = 0                         // In degrees
    var sectionAngle: Double = 45                   // In degrees

    override func draw(_ rect: CGRect)
    {
        if let sublayers = layer.sublayers
        {
            for layer in sublayers
            {
                layer.removeFromSuperlayer()
            }
        }
        
        let lineWidth: CGFloat = 5
        let pointSize: CGFloat = 8
        
        // Draw section
        // Calculate the points
        let leftOuterSectionPoint: CGPoint = CGPoint(x: (self.frame.width/2)+(self.frame.width/2)*sin(CGFloat.pi * CGFloat(-sectionAngle/2)/180), y: (self.frame.height/2)+(-self.frame.height/2)*cos(CGFloat.pi * CGFloat(-sectionAngle/2)/180))
        let rightOuterSectionPoint: CGPoint = CGPoint(x: (self.frame.width/2)+(self.frame.width/2)*sin(CGFloat.pi * CGFloat(sectionAngle/2)/180), y: (self.frame.height/2)+(-self.frame.height/2)*cos(CGFloat.pi * CGFloat(sectionAngle/2)/180))
        
        let sectionPath = UIBezierPath()
        let sectionLayer = CAShapeLayer()
        
        // Draw the shape
        sectionPath.move(to: leftOuterSectionPoint)
        sectionPath.addLine(to: CGPoint(x: self.frame.width/2, y: self.frame.height/2))
        sectionPath.addLine(to: rightOuterSectionPoint)
        
        sectionLayer.path = sectionPath.cgPath
        sectionLayer.fillColor = UIColor.clear.cgColor
        sectionLayer.strokeColor = UIColor.darkGray.cgColor
        sectionLayer.lineWidth = 2
        layer.addSublayer(sectionLayer)
        
        // Draw border circle
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        let borderCircleLayer = CAShapeLayer()
        borderCircleLayer.path = circlePath.cgPath
        borderCircleLayer.fillColor = UIColor.clear.cgColor
        borderCircleLayer.strokeColor = UIColor.black.cgColor
        borderCircleLayer.lineWidth = lineWidth
        layer.addSublayer(borderCircleLayer)
        
        // Draw points
        for point in pointsOfInterest
        {
            // Draw a point for each Point in points
            let pointLayer = CAShapeLayer()
            let gcPoint: CGPoint = CGPoint(
                x: sin(((point.angleInDegrees-self.heading)/180.0)*Double.pi)*(Double(point.distanceInMeters)/500.0)*Double(self.frame.width/2.0)+Double(self.frame.width/2.0),
                y: -cos(((point.angleInDegrees-self.heading)/180.0)*Double.pi)*(Double(point.distanceInMeters)/500.0)*Double(self.frame.height/2.0)+Double(self.frame.height/2.0))
            let pointPath = UIBezierPath(ovalIn: CGRect(origin: gcPoint, size: CGSize(width: pointSize, height: pointSize)))
            pointLayer.path = pointPath.cgPath
            if let type = point.type
            {
                switch(type)
                {
                    case PointOfInterestType.restaurant:
                        pointLayer.fillColor = UIColor.orange.cgColor
                        break
                    case PointOfInterestType.store:
                        pointLayer.fillColor = UIColor.blue.cgColor
                        break
                    default:
                        pointLayer.fillColor = UIColor.darkGray.cgColor
                        break
                }
            }
            else
            {
                pointLayer.fillColor = UIColor.darkGray.cgColor
            }
            pointLayer.strokeColor = UIColor.clear.cgColor
            pointLayer.lineWidth = 0
            layer.addSublayer(pointLayer)
        }
    }
    
    override func layoutSubviews()
    {
        layer.cornerRadius = bounds.size.width/2;
    }
    
}
