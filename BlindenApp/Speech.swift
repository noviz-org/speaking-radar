//
//  Speech.swift
//  BlindenApp
//
//  Created by Lukas Reitemeier on 11.03.18.
//  Copyright © 2018 Lukas Reitemeier. All rights reserved.
//

import Foundation
import AVFoundation

class Speech
{

    static let synthesizer = AVSpeechSynthesizer()
    
    static func speakPhrase(text: String)
    {
        let phrase = AVSpeechUtterance(string: text)
        phrase.rate = 0.5
        self.synthesizer.speak(phrase)
    }
    
}
