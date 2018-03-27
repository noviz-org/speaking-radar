//
//  Speech.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 11.03.18.
//  Copyright © 2018 Lukas Reitemeier. All rights reserved.
//

import Foundation
import AVFoundation

class Speech: NSObject, AVSpeechSynthesizerDelegate
{
    static var poisToSay: [PointOfInterest] = []
    static var lastSaidPOI: PointOfInterest? = nil

    static let synthesizer = AVSpeechSynthesizer()
    
    
    static func speakPhrase(text: String)
    {
        let phrase = AVSpeechUtterance(string: text)
        phrase.rate = 0.55
        self.synthesizer.speak(phrase)
    }
    
    static func startedSpeaking(utterance: AVSpeechUtterance)
    {
        self.lastSaidPOI = poisToSay.remove(at: 0)
        print("saying: "+utterance.attributedSpeechString.string)
    }
    
    static func startSearchPhrase()
    {
        //self.speakPhrase(text: "Suche nach Orten")
        print("startPhrase")
        //self.synthesizer.delegate = self
    }
    
    static func resultPhrase(point: PointOfInterest)
    {
        self.speakPhrase(text: point.title+" ist "+String(point.distanceInMeters)+" Meter entfernt.")
        self.poisToSay.append(point)
    }
    
    static func noResultsPhrase()
    {
        self.speakPhrase(text: "Keine Orte in dieser Richtung.")
    }
    
    static func getLastSaidPOI() -> PointOfInterest
    {
        return lastSaidPOI! // TODO das ist böse
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance)
    {
        Speech.startedSpeaking(utterance: utterance)
    }
    
}
