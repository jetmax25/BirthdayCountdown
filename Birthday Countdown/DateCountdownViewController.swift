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

class DateCountdownViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var topOfButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet var TimeDurationLabel: UILabel!
    @IBOutlet var EventLabel: UILabel!
    @IBOutlet weak var onlyLabel: UILabel!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var timeIntervalStack: UIStackView!
    @IBOutlet weak var shareStack: UIStackView!
    
    
    var bannerView: GADBannerView!
    var viewModel : DateCountdownViewModel?
    var timeChangeTimer : Timer?
    var backgroundImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        #if HALLOWEEN
        bannerView.adUnitID = "ca-app-pub-5594325776314197/5773099570"
            #elseif CHRISTMAS
            bannerView.adUnitID = "ca-app-pub-5594325776314197/1812182577"
            #endif
        bannerView.rootViewController = self
        bannerView.delegate = self
        let request = GADRequest()
        request.tag(forChildDirectedTreatment: true)
        request.testDevices = [kGADSimulatorID]
        bannerView.frame = adView.frame
        bannerView.load(request)
        self.view.addSubview(bannerView)
        
        viewModel = DateCountdownViewModel()
        changeTime(timeIncrement: .days, getTime: viewModel!.getDays, nextAction: 3600)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpFontsAndBackground()
    }
    
    func setUpFontsAndBackground() {
        
        OperationQueue.main.addOperation {
            if let backgroundImage = self.viewModel?.backgroundImage {
                self.view.setUpBlurryBackgroundImage(image: backgroundImage, withAlpha :0.35)
            } else {
                self.performSegue(withIdentifier: "chooseWallpaper", sender: nil)
                return
            }
        }
        
        #if HALLOWEEN
            self.EventLabel.text = "HALLOWEEN"
            self.EventLabel.textColor = .orange
            self.EventLabel.font = UIFont(name: "BloodLust", size: 200)
            self.TimeDurationLabel.textColor = .orange
            self.TimeDurationLabel.font = UIFont(name: "BloodLust", size: 200)
            self.timeCountLabel.textColor = .orange
            self.timeCountLabel.font = UIFont(name: "BloodLust", size: 200)
            self.onlyLabel.textColor = .orange
            self.onlyLabel.font = UIFont(name: "BloodLust", size: 200)
        #elseif CHRISTMAS
            
            self.EventLabel.text = "CHRISTMAS"
            self.EventLabel.font = UIFont(name: "PWJoyeuxNoel", size: 200)
            self.EventLabel.textColor = .red
            
            self.timeCountLabel.textColor = .red
            self.timeCountLabel.font = UIFont(name: "PWJoyeuxNoel", size: 200)
            
            self.TimeDurationLabel.textColor = UIColor(red: 54/255, green: 170/255, blue: 5/255, alpha: 1)
            self.TimeDurationLabel.font = UIFont(name: "PWJoyeuxNoel", size: 200)
            
            self.onlyLabel.font = UIFont(name: "PWJoyeuxNoel", size: 200)
            self.onlyLabel.textColor = UIColor(red: 54/255, green: 170/255, blue: 5/255, alpha: 1)
            self.view.setUpBlurryBackgroundImage(imageName: "AlmostChristmas.jpg", withAlpha: 0.35)
        #endif
        
        self.EventLabel.adjustFontToFitHeight()
        self.timeCountLabel.adjustFontToFitHeight()
        self.onlyLabel.adjustFontToFitHeight()
        self.TimeDurationLabel.adjustFontToFitHeight()
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
            ShowEvent()
        }
        
        timeChangeTimer?.invalidate()
        
        self.TimeDurationLabel.text = timeIncrement.rawValue + " Until"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:getTime()))!
        
        timeCountLabel.text = "\(formattedNumber)"
        timeChangeTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(nextAction), repeats: false, block: { _ in
            self.changeTime(timeIncrement: timeIncrement, getTime: getTime, nextAction: nextAction)
        })
    }
    
    private func ShowEvent() {
        self.viewModel!.stopMusic()
        
        OperationQueue.main.addOperation {
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
