//
//  DateCountdownViewModel.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 10/14/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct DateCountdownViewModel {
    var tickPlayer : AVAudioPlayer?
    var musicPlayer : AVAudioPlayer?
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    init() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            tickPlayer = try AVAudioPlayer(contentsOf: tickSound)
            musicPlayer = try AVAudioPlayer(contentsOf: countdownMusic)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var configDict : NSDictionary {
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")
        return NSDictionary(contentsOfFile: path!)!
    }
    
    var bannerAdId : String {
        return configDict["BannerAdId"] as! String
    }
    
    var font : UIFont {
        let font = configDict["Font"] as! NSDictionary
        let fontName = font["Name"] as! String
        return UIFont(name: fontName, size: 200)!
    }
    
    var fontColor : UIColor {
        let font = configDict["Font"] as! NSDictionary
        let fontCode = font["Color"] as! String
        return UIColor(hexColor : fontCode)
    }
    
    var eventDate : Date {
        return configDict["Date"] as! Date
    }
    
    var eventName : String {
        return configDict["Name"] as! String
    }
    
    var chosenDate : Date {
        return configDict["Date"] as! Date
    }
    
    var tickSound : URL {
        let soundName = configDict["TickSound"] as! String
        return Bundle.main.url(forResource: soundName, withExtension: "wav")!
    }
    
    var countdownMusic : URL {
        let soundName = configDict["CountdownMusic"] as! String
        return Bundle.main.url(forResource: soundName, withExtension: "mp3")!
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
        var currentTime = Date()
        if component == .day {
            currentTime = NSCalendar.current.startOfDay(for: currentTime)
        }
        
        tickPlayer?.play()
        return calendar.dateComponents([component], from: currentTime, to: chosenDate)
    }
    
    func stopMusic() {
        self.musicPlayer?.stop()
    }
    
    var fileUrl: URL {
        let url =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "SavedImage"
        return url.appendingPathComponent(fileName)
    }
    
    func setStoredPhoto( fromIndex index : Int ){
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: fileUrl)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(index, forKey: "backgroundImageIndex")
    }
    
    func setPhotoAsBackground(image : UIImage) {
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            try? imageData.write(to: fileUrl, options: .atomic)
        }
    }
    
    private func loadBackgroundImage() -> UIImage? {
        do {
            let imageData = try Data(contentsOf: fileUrl)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    private func loadStoredImage() -> UIImage? {
        let userDefaults = UserDefaults.standard
        if let imageIndex = userDefaults.object(forKey: "backgroundImageIndex") as? Int, let image = BackgroundImages.getImage(atIndex: imageIndex) {
            return image
        }
        return nil
    }
    
    var backgroundImage : UIImage? {
        if let userImage = loadBackgroundImage() {
            return userImage
        }
        if let storedImage = loadStoredImage() {
            return storedImage
        }
        return nil
    }
}
