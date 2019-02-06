//
//  ViewController.swift
//  userLocation
//
//  Created by Sebastian Hette on 19.09.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var locationController: LocationController? = nil
    
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
        // Call the super viewDidLoad function first
        super.viewDidLoad()
        
        locationController = LocationController()
        
        // Some tapping stuff... TODO
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        // Gestures
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

    // Actual gesture handeling
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
    if gesture.direction == UISwipeGestureRecognizerDirection.right {
        //print("Swipe Right")
    }
    else if gesture.direction == UISwipeGestureRecognizerDirection.left {
        //print("Swipe Left")
    }
    else if gesture.direction == UISwipeGestureRecognizerDirection.up {
        //print("Swipe Up")
        
        if let lc = locationController
        {
            Controller.loadPointsOfInterest(locationController: lc)
        }
        else
        {
            print("LocationController is nil")
        }
    }
    else if gesture.direction == UISwipeGestureRecognizerDirection.down {
        //print("Swipe Down")
    }
}
    
    
    
    // This function handles all the output (display and speaking) of the Points of Interest
    static func updateView(pointsOfInterest: [PointOfInterest])
    {
        if(pointsOfInterest.count > 0)
        {
            for point in pointsOfInterest
            {
                print(point.title+": "+String(point.distanceInMeters)+"m, Winkel: "+String(point.angleInDegrees))
                
                // Speech
                Speech.resultPhrase(point: point)
                
                // UI
                // TODO
            }
        }
        else
        {
            Speech.noResultsPhrase()
        }
    }
    
    // Overriding the Memory warining, nothing special yet
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


