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


    @IBOutlet weak var topOfButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var timeDescriptionImage: UIImageView!
    
    
    var bannerView: GADBannerView!
    var viewModel : BirthdayCountdownViewModel?
    var timeChangeTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerView.adUnitID = "ca-app-pub-5594325776314197/4976965253"
        bannerView.rootViewController = self
        bannerView.delegate = self
        let request = GADRequest()
        request.tag(forChildDirectedTreatment: true)
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
        self.view.addSubview(bannerView)
        
        topOfButtonsConstraint.constant = bannerView.frame.height
        let userDefaults = UserDefaults.standard
        let date = userDefaults.object(forKey: "Date") as! Date
        viewModel = BirthdayCountdownViewModel(chosenDate: date)
        changeTime(timeIncrement: .days, getTime: viewModel!.getDays, nextAction: 3600)
        
        self.view.setUpBlurryBackgroundImage(imageName: "BallonBackground.jpg")
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
    
    @IBAction func viewDays(_ sender: Any) {
        changeTime(timeIncrement: .days, getTime: viewModel!.getDays, nextAction: 3600)
    }
    @IBAction func viewHours(_ sender: Any) {
        changeTime(timeIncrement: .hours, getTime: viewModel!.getHours, nextAction: 60)
    }
    @IBAction func viewMinutes(_ sender: Any) {
        changeTime(timeIncrement: .minutes, getTime: viewModel!.getMinutes, nextAction: 60)
    }
    @IBAction func viewSeconds(_ sender: Any) {
        changeTime(timeIncrement: .seconds, getTime: viewModel!.getSeconds, nextAction: 1)
    }
    
    private func changeTime(timeIncrement : TimeIncrement, getTime : @escaping () -> Int, nextAction : Int)
    {
        let daysLeft = viewModel?.getDays()        
        if daysLeft == 0 {
            ShowBirthday()
        }
        
        timeChangeTimer?.invalidate()
        
        let imageName = timeIncrement.rawValue + ".png"
        let image = UIImage(named: imageName)
        self.timeDescriptionImage.image = image
        
        timeCountLabel.text = "\(getTime())"
        timeChangeTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(nextAction), repeats: false, block: { _ in
            self.changeTime(timeIncrement: timeIncrement, getTime: getTime, nextAction: nextAction)
        })
    }
    
    private func ShowBirthday() {
        let storyboard = UIStoryboard(name: "Birthday", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        self.present(controller!, animated: true, completion: nil)
    }
}
