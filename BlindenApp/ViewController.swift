//
//  ViewController.swift
//  Speaking Radar
//
//  Created by Lukas Bühler on 06.02.2019.
//  Copyright © 2019 NOVIZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{    
    @IBOutlet weak var orientationArrow: UIImageView!
    
    @IBOutlet weak var radarView: RadarView!
    
    @IBOutlet weak var speechTextField: UITextField!
    
    var controller: Controller? = nil
    
    let speechView: SpeechController = SpeechController()
    
    // Tap functions
    @objc func doubleTap()
    {
        // double tap recognized
        
        if let controller = controller
        {
            controller.stopSpeaking()
        }
    }
    
    @objc func singleTap()
    {
        // single tap recognized
        
        if let controller = controller
        {
            controller.speakSection()
        }
    }
    
    override func viewDidLoad()
    {
        // Call the super viewDidLoad function first
        super.viewDidLoad()
        
        controller = Controller(vc: self)
        
        // Single tap recognizer
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.singleTap))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)

        // Some tapping stuff... TODO
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)

        
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
            
            if let controller = self.controller
            {
                controller.navigateToPointOfInterest()
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            //print("Swipe Down")
            
            if let controller = self.controller
            {
                controller.loadGooglePlaces()
            }
        }
    }
    
    func updateRadarPoints(pois: [PointOfInterest]) -> Void
    {
        DispatchQueue.main.async {
            self.radarView.pointsOfInterest = pois;
            self.radarView.setNeedsDisplay() // redraw
        }
    }
    func updateRadarHeading(heading: Double) -> Void
    {
        DispatchQueue.main.async
            {
            self.radarView.heading = heading
            self.radarView.setNeedsDisplay() // redraw
        }
    }
    func setRadarSectionAngle(angle: Double) -> Void
    {
        DispatchQueue.main.async {
            self.radarView.sectionAngle = angle
            self.radarView.setNeedsDisplay()
        }
    }
    
    func updateOrientationArrow(heading: Double)
    {
        self.orientationArrow.transform = CGAffineTransform(rotationAngle: (CGFloat(-(heading*Double.pi/180)) - CGFloat(Double.pi / 4)))
    }
    
    // Overriding the Memory warining, nothing special yet
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


