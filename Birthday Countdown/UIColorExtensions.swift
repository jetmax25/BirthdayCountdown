//
//  UIColorExtensions.swift
//  Its Almost My Birthday
//
//  Created by Michael Isasi on 11/2/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexColor : String) {
        var cString:String = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
    
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green:  CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1)
    }
}
