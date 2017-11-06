//
//  BackgroundImagesEnum.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 10/17/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit

struct BackgroundImages {
    static var images : [String] {
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")
        let configDict =  NSDictionary(contentsOfFile: path!)!
        return configDict["Photos"] as! [String]
    }
    
    static func getImage(atIndex index : Int) -> UIImage?
    {
        let imageName = images[index]
        return UIImage(named : imageName)
    }
    
    static func count() -> Int {
        return images.count
    }
    
    
}
