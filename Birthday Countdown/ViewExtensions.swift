//
//  ViewExtensions.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 9/30/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit


extension UIView {
    
    func setUpBlurryBackgroundImage( imageName : String, withAlpha alpha : CGFloat? = nil ) {
        self.setUpBlurryBackgroundImage(image: UIImage(named: imageName)!, withAlpha: alpha)
    }
    
    func setUpBlurryBackgroundImage( image : UIImage, withAlpha alpha : CGFloat? = nil ) {

        if let oldImage = self.viewWithTag(123) {
            oldImage.removeFromSuperview()
        }
        
        if let oldBlur = self.viewWithTag(124) {
            oldBlur.removeFromSuperview()
        }
        
        let backgroundImage = UIImageView()
        backgroundImage.frame = CGRect(x: self.frame.minX - 20, y: self.bounds.minY - 20, width: self.bounds.width + 20, height: self.bounds.height + 40)
        backgroundImage.image = image
        backgroundImage.tag = 123
        backgroundImage.contentMode = .scaleAspectFill
        let blurImage = UIView()
        blurImage.tag = 124
        blurImage.frame = self.frame
        blurImage.backgroundColor = .white
        blurImage.alpha = alpha ?? 0.6
        self.addSubview(backgroundImage)
        self.addSubview(blurImage)
        self.sendSubview(toBack: blurImage)
        self.sendSubview(toBack: backgroundImage)
    }
}
