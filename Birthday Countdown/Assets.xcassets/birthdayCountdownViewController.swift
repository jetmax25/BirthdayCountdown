//
//  birthdayCountdownViewController.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/4/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit
import GoogleMobileAds

class birthdayCountdownViewController: UIViewController, GADBannerViewDelegate {

    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-5594325776314197/4976965253"
        bannerView.rootViewController = self
        bannerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
