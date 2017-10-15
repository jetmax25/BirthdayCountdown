//
//  DateCountdownViewModel.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 10/14/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation
import AVFoundation

struct DateCountdownViewModel {
    let chosenDate : Date
    var tickPlayer : AVAudioPlayer?
    let tickSound : URL?
    var musicPlayer : AVAudioPlayer?
    let backgroundMusic : URL?
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    init() {
        var month : Int?
        var day : Int?
        
        #if HALLOWEEN
            month = 10
            day = 31
            tickSound = Bundle.main.url(forResource: "HorrorTick", withExtension: "wav")!
            backgroundMusic = Bundle.main.url(forResource: "AlmostHalloween", withExtension: "mp3")!
        #elseif CHRISTMAS
            month = 12
            day = 25
            tickSound = Bundle.main.url(forResource: "chime", withExtension: "wav")!
            backgroundMusic = Bundle.main.url(forResource: "JingleBells", withExtension: "mp3")!
        #endif
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        var year = currentComponents.year!
        if currentComponents.month! > month! || (currentComponents.day! > day! && currentComponents.month! == month!)
        {
            year = year + 1
        }
        
        let dateString = "\(year)-\(month!)-\(day!)"
        self.chosenDate = dateFormatter.date(from: dateString)!
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            tickPlayer = try AVAudioPlayer(contentsOf: tickSound!)
            musicPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.play()
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
        tickPlayer?.play()
        return calendar.dateComponents([component], from: currentTime, to: chosenDate)
    }
    
    func stopMusic() {
        self.musicPlayer?.stop()
    }
}
