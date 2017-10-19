//
//  BackgroundImagesEnum.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 10/17/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit

struct BackgroundImages {
    static let images : [String : UIImage] = [
        "castle" : UIImage(named: "castle.jpg")!,
        "doot" : UIImage(named: "doot.jpg")!,
        "harvest" : UIImage(named: "harvest.jpg")!,
        "jack" : UIImage(named: "jack.jpg")!,
        "jacks" : UIImage(named: "jacks.jpg")!,
        "candles" : UIImage(named: "candles.jpg")!
    ]
    
    static func getImage( key : String) -> UIImage
    {
        return images[key]!
    }
    
    static func getImage(_ n : Int) -> UIImage
    {
        let key = Array(images.keys)[n]
        return images[key]!
    }
    
    static func getImageName(_ n : Int) -> String
    {
        return Array(images.keys)[n]
    }
    
    static func count() -> Int {
        return images.count
    }
    
    
}
