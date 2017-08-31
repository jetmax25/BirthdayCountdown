//
//  BirthdayViewController.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/4/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit
import AVFoundation

class BirthdayViewController: UIViewController {

    var audioPlayer : AVAudioPlayer?
    var alertSound : URL?
    @IBOutlet weak var muteImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(muteSound(tapGestureRecognizer:)))
        
        muteImage.addGestureRecognizer(tap)
        
        view.isUserInteractionEnabled = true
        
        alertSound = Bundle.main.url(forResource: "BirthdaySong", withExtension: "mp3")!
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound!)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func muteSound(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let audioPlayer = audioPlayer else {
            return
        }
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            self.muteImage.image = UIImage(named: "UnMute.png")
        } else {
            audioPlayer.play()
            self.muteImage.image = UIImage(named: "Mute.png")
        }
    }
}
