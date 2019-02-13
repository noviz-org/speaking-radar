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
    
    @IBOutlet weak var lastSpokenPlaceLabel: UILabel!
    
    var controller: Controller? = nil
    
    let speechView: SpeechController = SpeechController()
    
    override func viewDidLoad()
    {
        // Call the super viewDidLoad function first
        super.viewDidLoad()
        
        radarView.start(vc: self)
    
        //self.view.isAccessibilityElement = true
        //self.view.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction

        // Label
        self.lastSpokenPlaceLabel.isAccessibilityElement = true
        self.lastSpokenPlaceLabel.accessibilityTraits = UIAccessibilityTraitStaticText
        self.lastSpokenPlaceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.lastSpokenPlaceLabel.adjustsFontForContentSizeCategory = true

        // Radar View
        self.radarView.isAccessibilityElement = true
        self.radarView.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction
        self.radarView.accessibilityLabel = "Radar"
        self.radarView.accessibilityValue = "No places loaded."
        self.radarView.accessibilityHint = "Swipe down to load places."

        
        controller = Controller(vc: self)
        
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
    
    func updateLastSpokenTextField(text: String)
    {
        lastSpokenPlaceLabel.text = text
    }
    
    // Overriding the Memory warining, nothing special yet
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


