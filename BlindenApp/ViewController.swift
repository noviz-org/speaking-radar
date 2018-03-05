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
import AVFoundation

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
    
    let synthesizer = AVSpeechSynthesizer()
    var speak = AVSpeechUtterance(string: "Text")
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        let x = newHeading.x
        let y = newHeading.y
        let z = newHeading.z
        // change
        // change 2
        // Sets the text of the label to the three compass coordinates
        compassLabel.text = String("(\(x),\(y),\(z))");
        print("Compass: (\(x),\(y),\(z))")
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        Poi.getPois();
        
        speak = AVSpeechUtterance(string: "Heeeyyyooo, alles geladen")
        speak.rate = 0.4
        synthesizer.speak(speak)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    static func parseData(data: Data) -> GooglePlacesResponse?
    {
        let response: GooglePlacesResponse
        do
        {
            response = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
        }
        catch _
        {
            return nil
        }
        return response
    }
}


