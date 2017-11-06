//
//  BirthdayCountdownViewModel.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/6/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct BirthdayCountdownViewModel {
    let chosenDate : Date
    let calendar = NSCalendar.current
    var audioPlayer : AVAudioPlayer?
    let alertSound : URL?
    
    init(chosenDate : Date) {
        self.chosenDate = chosenDate
        alertSound = Bundle.main.url(forResource: "ClockTick", withExtension: "wav")!
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound!)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getDays() -> Int {
        return getTimeDifference(component: .day).day!
    }
    
    func getHours() -> Int {
        return getTimeDifference(component: .hour).hour!
    }
    
    func getMinutes() -> Int {
        return getTimeDifference(component: .minute).minute!
    }
    
    func getSeconds() -> Int {
        return getTimeDifference(component: .second).second!
    }
    
    private func getTimeDifference( component : Calendar.Component) -> DateComponents
    {
        let currentTime = Date()
        audioPlayer?.play()
        return calendar.dateComponents([component], from: currentTime, to: chosenDate)
    }
}
