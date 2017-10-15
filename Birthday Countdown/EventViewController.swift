//
//  EventViewController.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 10/14/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit
import AVFoundation

class EventViewController: UIViewController {

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var appAdView: UIView!
    
    let unMuteImage = UIImage(named: "UnMute.png")
    let muteImage = UIImage(named: "Mute.png")
    var audioPlayer : AVAudioPlayer?
    var backgroundMusic : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = true
        
        setUpView()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic!)
            audioPlayer?.play()
            audioPlayer?.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @IBAction func muteSound(_ sender: Any) {
        guard let audioPlayer = audioPlayer else {
            return
        }
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            self.muteButton.setBackgroundImage(unMuteImage, for: .normal)
        } else {
            audioPlayer.play()
            self.muteButton.setBackgroundImage(muteImage, for: .normal)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setUpView()
    }
    
    private func setUpView() {
        #if HALLOWEEN
            backgroundMusic = Bundle.main.url(forResource: "ItsHalloween", withExtension: "wav")!
            self.eventLabel.text = "It's\nHalloween\n!!!"
            self.eventLabel.font = UIFont(name: "BloodLust", size: 200)
            self.eventLabel.adjustFontToFitHeight()
            self.view.setUpBlurryBackgroundImage(imageName: "ItsHalloween.png", withAlpha: 0.2)
            self.eventLabel.textColor = .orange
        #elseif CHRISTMAS
            backgroundMusic = Bundle.main.url(forResource: "WishYouMerryChristmas", withExtension: "mp3")!
            self.eventLabel.text = "It's\nChristmas\n!!!"
            self.eventLabel.font = UIFont(name: "PWJoyeuxNoel", size: 200)
            self.eventLabel.adjustFontToFitHeight()
            self.view.setUpBlurryBackgroundImage(imageName: "ItsChristmas.jpg", withAlpha: 0.2)
            self.eventLabel.textColor = .red
        #endif
    }
}
