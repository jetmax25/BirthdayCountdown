//
//  ViewExtensions.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 9/30/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit


extension UIView {
    
    func setUpBlurryBackgroundImage( imageName : String ) {
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: self.frame.minX - 25, y: self.frame.minY - 25, width: self.frame.width + 50, height: self.frame.height + 50)
        backgroundImage.image = UIImage(named: imageName)
        
        let blurImage = UIView()
        blurImage.frame = self.frame
        blurImage.backgroundColor = .white
        blurImage.alpha = 0.7
        
        self.addSubview(backgroundImage)
        self.addSubview(blurImage)
        self.sendSubview(toBack: blurImage)
        self.sendSubview(toBack: backgroundImage)

    }
}
