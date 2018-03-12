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
    
    @IBOutlet weak var winkelEingabe: UITextField!

    @IBOutlet weak var touch_cordinate: UILabel!
    
    @IBOutlet weak var Button1: UIButton!
    
    var i = 1
    
    let manager = CLLocationManager()
    
    var pois: [PointOfInterest] = []
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        print(location.course)

        latitudeLabel.text = String(location.coordinate.latitude)
        longitudeLabel.text = String(location.coordinate.longitude)
        courseLocation.text = String(location.course)
        
        self.map.showsUserLocation = true

        i = i+1
        print("LocationManager func did run \(i) times")
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading)
    {
        compassLabel.text = String("Angle: \(heading.trueHeading)");
        print("Angle: \(heading.trueHeading)")
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
        // do something here
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Speech.speakPhrase(text: "Heeeyyyooo, alles geladen")
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        POIs.getPois(location: WorldLocation(lat: 47.366696, lng: 8.545235));
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}


