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
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    var bannerView: GADBannerView!
    var viewModel : BirthdayCountdownViewModel?
    var timeChangeTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-5594325776314197/4976965253"
        bannerView.rootViewController = self
        bannerView.delegate = self
        let request = GADRequest()
        request.tag(forChildDirectedTreatment: true)
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
        
        topOfButtonsConstraint.constant = bannerView.frame.height
        let userDefaults = UserDefaults.standard
        let date = userDefaults.object(forKey: "Date") as! Date
        viewModel = BirthdayCountdownViewModel(chosenDate: date)
        changeTime(label: "Days", getTime: viewModel!.getDays, nextAction: 3600)
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
        changeTime(label: "Days", getTime: viewModel!.getDays, nextAction: 3600)
    }
    @IBAction func viewHours(_ sender: Any) {
        changeTime(label: "Hours", getTime: viewModel!.getHours, nextAction: 60)
    }
    @IBAction func viewMinutes(_ sender: Any) {
        changeTime(label: "Minutes", getTime: viewModel!.getMinutes, nextAction: 60)
    }
    @IBAction func viewSeconds(_ sender: Any) {
        changeTime(label: "Seconds", getTime: viewModel!.getSeconds, nextAction: 1)
    }
    
    private func changeTime(label : String, getTime : @escaping () -> Int, nextAction : Int)
    {
        let daysLeft = viewModel?.getDays()
        if daysLeft! <= 0 {
            UpdateBirthday()
        }
        
        if daysLeft == 0 {
            ShowBirthday()
        }
        
        timeChangeTimer?.invalidate()
        timeDescriptionLabel.text = label
        timeCountLabel.text = "\(getTime())"
        timeChangeTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(nextAction), repeats: false, block: { _ in
            self.changeTime(label: label, getTime: getTime, nextAction: nextAction)
        })
    }
    
    private func UpdateBirthday() {
        let date = viewModel?.chosenDate
        let newDate = Calendar.current.date(byAdding: .year, value: 1, to: date!)
        let userDefaults = UserDefaults.standard
        userDefaults.set(newDate, forKey: "Date")
    }
    
    private func ShowBirthday() {
        let storyboard = UIStoryboard(name: "Birthday", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        self.present(controller!, animated: true, completion: nil)
    }
}
