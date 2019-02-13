//
//  Speech.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 11.03.18.
//  Copyright Copyright © 2019 NOVIZ. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechController: NSObject, AVSpeechSynthesizerDelegate
{
    var lastSaidId: String? = nil
    var lastSaidPointOfInterestIndex: Int = 0
    var pointsOfInterest: [PointOfInterest] = []
    var utteranceIndexOffset: Int = 0
    
    let synthesizer = AVSpeechSynthesizer()
    
    var lastPoiUpdatedCallbacks: [(String) -> Void] = []
    
    override init()
    {
        super.init()
        synthesizer.delegate = self
    }
    
    func sayPhrase(text: String)
    {
        let phrase = AVSpeechUtterance(string: text)
        phrase.rate = 0.5
        self.synthesizer.speak(phrase)
    }
    
    func startedSpeaking(utterance: AVSpeechUtterance)
    {
        //print("Hello - " + utterance.attributedSpeechString.string )
        print("lastSaidPointOfInterestIndex = " + String(lastSaidPointOfInterestIndex))
        print("utteranceIndexOffset = " + String(utteranceIndexOffset))
        print("pointsOfInterest.count = " + String(pointsOfInterest.count))
        
        if(utteranceIndexOffset <= lastSaidPointOfInterestIndex)
        {
            // There are more Point of views to say
            lastSaidId = pointsOfInterest[lastSaidPointOfInterestIndex - utteranceIndexOffset].id
            self.lastSaidPointOfInterestUpdated()
        }
        lastSaidPointOfInterestIndex = lastSaidPointOfInterestIndex + 1 // Somehow ++ won't work
    }
    
    func getLastSaidPlaceId() -> String?
    {
        return lastSaidId
    }
    
    func lastSaidPointOfInterestUpdated()
    {
        if let id = self.lastSaidId
        {
            for f in lastPoiUpdatedCallbacks
            {
                f(id)
            }
        }
    }
    
     func speakLoadingPointsOfInterest()
    {
        self.utteranceIndexOffset = 1
        lastSaidPointOfInterestIndex = 0
        self.sayPhrase(text: "Loading points of interest")
        //print("startPhrase")
        //self.synthesizer.delegate = self
    }
    
     func speakDoneLoading(poi_count: Int, radius: Int)
    {
        self.utteranceIndexOffset = 1
        lastSaidPointOfInterestIndex = 0
        self.sayPhrase(text: "Done. Found \(poi_count) points of interest in a radius of \(radius) meters ")
    }
    
    func speakPointsOfInterestSection(radius_sorted_points: [PointOfInterest])
    {
        self.pointsOfInterest = radius_sorted_points
        lastSaidPointOfInterestIndex = 0

        switch(radius_sorted_points.count)
        {
            case 0:
                utteranceIndexOffset = 1
                self.sayPhrase(text: "No points of interest in this direction.")
                break
            case 1:
                utteranceIndexOffset = 1
                self.sayPhrase(text: "There is one point of interest in this direction.")
                let point = radius_sorted_points[0]
                self.sayPhrase(text: "\(point.title) in \(point.distanceInMeters) meters.")
                break
            default:
                utteranceIndexOffset = 1
                self.sayPhrase(text: "There are \(radius_sorted_points.count) points in this direction.")
                for point in radius_sorted_points
                {
                    self.sayPhrase(text: "\(point.title) in \(point.distanceInMeters) meters.")
                }
                break
        }
    }
    
    func noResultsPhrase()
    {
        self.sayPhrase(text: "Nothing in this direction.")
    }
    
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance)
    {
        // Runs when something is spoken
        self.startedSpeaking(utterance: utterance)
    }
}
