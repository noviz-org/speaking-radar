//
//  ViewController.swift
//  userLocation
//
//  Created by Sebastian Hette on 19.09.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var courseLocation: UILabel!
    @IBOutlet weak var compassLabel: UILabel!

    @IBOutlet weak var touch_cordinate: UILabel!
    
    var currentLocation: CLLocation?
    var currentAngle: Double?
    
    let manager = CLLocationManager()
    
    var pois: [PointOfInterest] = []
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("locations: "+String(locations.count))
        currentLocation = locations[0]
        
        if let location = currentLocation
        {
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            map.setRegion(region, animated: true)
            
            print(location.course)
            
            latitudeLabel.text = String(location.coordinate.latitude)
            longitudeLabel.text = String(location.coordinate.longitude)
            courseLocation.text = String(location.course)
            
            self.map.showsUserLocation = true
        }
        else
        {
            print("cannot resolve location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading)
    {
        compassLabel.text = String("Angle: \(heading.trueHeading)");
        currentAngle = heading.trueHeading
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            print(position)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            print(position)
        }
    }
    
    @objc func doubleTapped() {
        // double tap found.
        print("AVSpeechSynthesizer_Status:")
        print(Speech.synthesizer.isSpeaking)
        
        if (Speech.synthesizer.isSpeaking) {
            Speech.synthesizer.stopSpeaking(at: .immediate)
            print("was speaking, is now stoped")
        }
        else {
            print("is not speaking")
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        // Start
        if let location = currentLocation
        {
            print(location)
            Controller.fetchAndReturnPointsOfInterest(location: CoordinateLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude), currentOrientation: currentAngle!)
        }
        else
        {
            print("cannot resolve location")
        }
        

        
        let circle = CAShapeLayer()
        circle.path = circlePathWithCenter(center: CGPoint(x: 200,y: 400), radius: 50).cgPath
        circle.fillColor = UIColor.blue.cgColor
        self.view.layer.addSublayer(circle)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
    if gesture.direction == UISwipeGestureRecognizerDirection.right {
        print("Swipe Right")
    }
    else if gesture.direction == UISwipeGestureRecognizerDirection.left {
        print("Swipe Left")
    }
    else if gesture.direction == UISwipeGestureRecognizerDirection.up {
        print("Swipe Up")
        
        print("AVSpeechSynthesizer_Status:")
        print(Speech.synthesizer.isSpeaking)
        
        if (Speech.synthesizer.isSpeaking) {
            Speech.synthesizer.stopSpeaking(at: .immediate)
            print("was speaking, is now stoped")
        }
        else {
            print("is not speaking")
        }
        
        
        if let location = currentLocation
        {
            Controller.fetchAndReturnPointsOfInterest(location: CoordinateLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude), currentOrientation: currentAngle!)
        }
        else
        {
            print("cannot resolve location")
        }
    }
    else if gesture.direction == UISwipeGestureRecognizerDirection.down {
        print("Swipe Down")
    }
}

    func circlePathWithCenter(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: center, radius: radius, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: -CGFloat(Double.pi/2), endAngle: 0, clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
        circlePath.close()
        return circlePath
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static func outputPointsOfInterest(pointsOfInterest: [PointOfInterest])
    {
        if(pointsOfInterest.count > 0)
        {
            for point in pointsOfInterest
            {
                print(point.title+": "+String(point.distanceInMeters)+"m, Winkel: "+String(point.angleInDegrees))
                
                // Speech
                Speech.speakPhrase(text: point.title+" ist "+String(point.distanceInMeters)+" Meter entfernt.")
                
                // UI
                // TODO
            }
        }
        else
        {
            Speech.speakPhrase(text: "Keine signifikanten Punkte in diese Richtung gefunden")
        }
    }
    
}


