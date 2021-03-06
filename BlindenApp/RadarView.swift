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
    var viewController: ViewController?
    var pointsOfInterest: [PointOfInterest] = [];
    var heading: Double = 0                         // In degrees
    var sectionAngle: Double = 45                   // In degrees
    
    func start(vc: ViewController)
    {        // Assign ViewController
        self.viewController = vc
        
        // Single tap recognizer
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.singleTap))
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
        
        // Some tapping stuff... TODO
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
        
        // Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)
    }
    
    // Tap functions
    @objc func doubleTap()
    {
        // double tap recognized
        
        if let vc = viewController
        {
            if let controller = vc.controller
            {
                controller.stopSpeaking()
            }
        }
    }
    
    @objc func singleTap()
    {
        // single tap recognized
        
        if let vc = viewController
        {
            if let controller = vc.controller
            {
                controller.speakSection()
            }
        }
    }

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
        let positionPointSize: CGFloat = 20
        
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
        sectionLayer.strokeColor = UIColor.black.cgColor
        sectionLayer.lineWidth = 2
        layer.addSublayer(sectionLayer)
        
        // Draw location point
        let pointPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: self.frame.width/2 - positionPointSize/2, y: self.frame.height/2 - positionPointSize/2), size: CGSize(width: positionPointSize, height: positionPointSize)))
        let pointLayer = CAShapeLayer()
        pointLayer.path = pointPath.cgPath
        pointLayer.strokeColor = UIColor.black.cgColor
        pointLayer.lineWidth = 0
        layer.addSublayer(pointLayer)
        
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
            let pointPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: gcPoint.x-pointSize/2, y: gcPoint.y-pointSize/2), size: CGSize(width: pointSize, height: pointSize)))
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
    
    // Actual gesture handeling
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void
    {
        if gesture.direction == UISwipeGestureRecognizerDirection.right
        {
            //print("Swipe Right")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left
        {
            //print("Swipe Left")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up
        {
            //print("Swipe Up")
            
            if let vc = viewController
            {
                if let controller = vc.controller
                {
                    controller.navigateToPointOfInterest()
                }
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            //print("Swipe Down")
            
            if let vc = viewController
            {
                if let controller = vc.controller
                {
                    controller.loadGooglePlaces()
                }
            }
        }
    }

    
}

