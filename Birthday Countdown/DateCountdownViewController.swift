//
//  DateCountdownViewController.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 10/14/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Social
import Fabric
import Firebase

class DateCountdownViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var topOfButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet var TimeDurationLabel: UILabel!
    @IBOutlet var EventLabel: UILabel!
    @IBOutlet weak var onlyLabel: UILabel!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var timeIntervalStack: UIStackView!
    @IBOutlet weak var shareStack: UIStackView!
    @IBOutlet weak var shareText: UILabel!
    @IBOutlet weak var daysButton: UIButton!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var minutesButton: UIButton!
    @IBOutlet weak var SecondsButton: UIButton!
    
    @IBOutlet weak var removeAdsButton: UIButton!
    
    var bannerView: GADBannerView!
    var viewModel : DateCountdownViewModel?
    var timeChangeTimer : Timer?
    var backgroundImage : String?
    var adPlayed = false
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeAd), name: .removeAd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseFailed), name: .failedPurchase, object: nil)
        AppDelegate.interstitial?.delegate = self
        super.viewDidLoad()
        viewModel = DateCountdownViewModel()
        self.setActiveButton(self.SecondsButton)
        changeTime(timeIncrement: .days, getTime: viewModel!.getSeconds, nextAction: 1)
        
        if !viewModel!.requestedReview || AppDelegate.adFree {
            adPlayed = true
        }
    }
    
    func setAds() {
        
        if !AppDelegate.adFree {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView.adUnitID = viewModel?.bannerAdId
            bannerView.rootViewController = self
            bannerView.delegate = self
            let request = GADRequest()
            request.tag(forChildDirectedTreatment: true)
            request.testDevices = [kGADSimulatorID]
            bannerView.frame = adView.frame
            bannerView.load(request)
            self.view.addSubview(bannerView)
        } else {
            self.bannerView.removeFromSuperview()
            self.removeAdsButton.removeFromSuperview()
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        presentAd(location: "View Did Appear")
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpFontsAndBackground()
        self.setAds()
    }
    
    func presentAd( location : String ) {
        if AppDelegate.adFree, self.adPlayed {
            return
        }
        if viewModel!.requestedReview {
            if AppDelegate.interstitial?.isReady ?? false {
                Answers.logCustomEvent(withName: "Presenting Ad", customAttributes: [ "Location" : location ])
                AppDelegate.interstitial?.present(fromRootViewController: self)
                self.adPlayed = true
            } else {
                Answers.logCustomEvent(withName: "Failed To Present Ad", customAttributes: [ "Location" : location])
            }
        }
    }
//
//    func loadAd() {
//        numAds = numAds + 1
//        Answers.logCustomEvent(withName: "New Ad Loaded", customAttributes: ["AdNum" : numAds ])
//        AppDelegate.interstitial = GADInterstitial(adUnitID: "ca-app-pub-5594325776314197/5058013154")
//        let request = GADRequest()
//        AppDelegate.interstitial?.load(request)
//    }
    
    private func setCustomText(label: UILabel, isAltColor : Bool = false, text: String? = nil, fontSize : CGFloat? = nil) {
        if let text = text {
            label.text = text
        }

        label.font = viewModel?.font
        
        if let fontSize = fontSize {
            label.font = label.font.withSize(fontSize)
        }
        label.textColor =  isAltColor ? viewModel?.altFontColor : viewModel?.fontColor
    }
    
    func setUpFontsAndBackground() {
        
        OperationQueue.main.addOperation {
            if let backgroundImage = self.viewModel?.backgroundImage {
                self.view.setUpBlurryBackgroundImage(image: backgroundImage, withAlpha :0.25)
            } else {
                self.performSegue(withIdentifier: "chooseWallpaper", sender: nil)
                return
            }
        }

        self.setCustomText(label: self.EventLabel, isAltColor: true, text: viewModel?.eventName)
        self.setCustomText(label: self.TimeDurationLabel)
        self.setCustomText(label: timeCountLabel, isAltColor: true)
        self.setCustomText(label: onlyLabel)
        self.setCustomText(label: shareText, text: "Share Your Countdown", fontSize : 16)
        self.shareText.adjustsFontSizeToFitWidth = true
        
        self.SecondsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.daysButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.hoursButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.minutesButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.setCustomText(label: minutesButton.titleLabel!, fontSize : 24)
        self.setCustomText(label: SecondsButton.titleLabel!, fontSize : 24)
        self.setCustomText(label: daysButton.titleLabel!, fontSize : 24)
        self.setCustomText(label: hoursButton.titleLabel!, fontSize : 24)
        
        self.minutesButton.setTitleShadowColor(.black, for: .normal)
        self.minutesButton.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        
        self.hoursButton.setTitleShadowColor(.black, for: .normal)
        self.hoursButton.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        
        self.daysButton.setTitleShadowColor(.black, for: .normal)
        self.daysButton.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        
        self.SecondsButton.setTitleShadowColor(.black, for: .normal)
        self.SecondsButton.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        
        setActiveButton(self.daysButton)

        self.EventLabel.adjustFontToFitHeight()
        self.timeCountLabel.adjustFontToFitHeight()
        self.onlyLabel.adjustFontToFitHeight()
        self.TimeDurationLabel.adjustFontToFitHeight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setActiveButton( _ button : UIButton) {
        self.minutesButton.setTitleColor(viewModel?.fontColor, for: .normal)
        self.daysButton.setTitleColor(viewModel?.fontColor, for: .normal)
        self.hoursButton.setTitleColor(viewModel?.fontColor, for: .normal)
        self.SecondsButton.setTitleColor(viewModel?.fontColor, for: .normal)
        button.setTitleColor(viewModel?.altFontColor, for: .normal)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    @IBAction func viewDays(_ sender: Any) {
        setActiveButton(self.daysButton)
        changeTime(timeIncrement: .days, getTime: viewModel!.getDays, nextAction: 3600)
    }
    @IBAction func viewHours(_ sender: Any) {
        self.setActiveButton(self.hoursButton)
        changeTime(timeIncrement: .hours, getTime: viewModel!.getHours, nextAction: 60)
    }
    @IBAction func viewMinutes(_ sender: Any) {
        self.setActiveButton(self.minutesButton)
        changeTime(timeIncrement: .minutes, getTime: viewModel!.getMinutes, nextAction: 60)
    }
    @IBAction func viewSeconds(_ sender: Any) {
        self.setActiveButton(self.SecondsButton)
        changeTime(timeIncrement: .seconds, getTime: viewModel!.getSeconds, nextAction: 1)
    }
    
    private func changeTime(timeIncrement : TimeIncrement, getTime : @escaping () -> Int, nextAction : Int)
    {
        let daysLeft = viewModel?.getDays()
        if daysLeft == 0 {
            ShowEvent()
        }
        
        timeChangeTimer?.invalidate()
        
        self.TimeDurationLabel.text = timeIncrement.rawValue + " Until"
        
        #if BIRTHDAY
            self.TimeDurationLabel.text = self.TimeDurationLabel.text! + " My"
            #endif
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:getTime()))!
        
        timeCountLabel.text = "\(formattedNumber)"
        timeChangeTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(nextAction), repeats: false, block: { _ in
            self.changeTime(timeIncrement: timeIncrement, getTime: getTime, nextAction: nextAction)
        })
        
        if !viewModel!.requestedReview {
            self.adPlayed = true
            if #available(iOS 10.3, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    if !self.viewModel!.requestedReview {
                        self.viewModel!.requestedReview = true
                        SKStoreReviewController.requestReview()
                        UserDefaults.standard.set(true, forKey: "AskedReview")
                    }
                })
            }
        } else {
            presentAd(location: "Change Time")
        }
    }
    
    private func ShowEvent() {
        self.viewModel!.stopMusic()
        
        OperationQueue.main.addOperation {
            
            #if BIRTHDAY
                let bStoryboard = UIStoryboard(name: "Birthday", bundle: nil)
                let bController = bStoryboard.instantiateInitialViewController()
                self.present(bController!, animated: true, completion: nil)
                return
            #endif
            
            let storyboard = UIStoryboard(name: "Event", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()
            self.present(controller!, animated: true, completion: nil)
        }
    }
    
    private func getShareImage() -> UIImage {
        let startingY = self.timeIntervalStack.frame.maxY
        let endingY = self.shareStack.frame.minY
        
        let rect : CGRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: context)
        let img : UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let newRect: CGRect = CGRect(x: 0, y: startingY, width: self.view.bounds.width, height: endingY - startingY)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = img.cgImage!.cropping(to: newRect)!
        
        let newImg = UIImage(cgImage: imageRef)
        return newImg
    }
    
    @IBAction func shareOnFacebook(_ sender: Any) {
        if let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook) {
            let image = getShareImage()
            vc.add(image)
            vc.setInitialText("soon")
            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func removeAds(_ sender: Any) {
        self.removeAdsButton.isEnabled = false
        PurchaseHelper.purchase()
    }
    
    @objc func removeAd() {
        self.bannerView?.removeFromSuperview()
        self.removeAdsButton?.removeFromSuperview()
        AppDelegate.adFree = true
        UserDefaults.standard.set(true, forKey: "AdFree")
    }
    
    @objc func purchaseFailed() {
        self.removeAdsButton?.isEnabled = true
    }
    
    @IBAction func shareOnTwitter(_ sender: Any) {
        if let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter) {
            vc.add(getShareImage())
            vc.setInitialText("Soon")
            self.present(vc, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! BackgroundChooserViewController
        vc.viewModel = self.viewModel
    }
}
