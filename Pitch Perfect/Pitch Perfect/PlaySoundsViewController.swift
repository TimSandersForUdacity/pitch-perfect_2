//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Timothy T Sanders on 4/9/15.
//  Copyright (c) 2015 udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

	var audioEngine:AVAudioEngine!
	var audioFile:AVAudioFile!

	var audioPlayer:AVAudioPlayer!
	var receivedAudio: RecordedAudio!
	var fileURL: NSURL!
	
	@IBOutlet weak var stop_button: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		audioEngine = AVAudioEngine()
		audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
		
		var error:	NSError?
		audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
		if let error = error {
			println("Audio Error: \(error)")
		}
		audioPlayer.enableRate = true
		stop_button.hidden = true
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBAction func playDarthVaderAudio(sender: UIButton) {
		playAudioWithVariablePitch(-1000)
	}
	
	@IBAction func playChipmunkAudio(sender: UIButton) {
		playAudioWithVariablePitch(1000)
	}
	
	
	func playAudioWithVariablePitch(pitch: Float){
		audioPlayer.currentTime = 0.0
		audioPlayer.rate = 1.0
		audioPlayer.stop()
		audioEngine.stop()
		audioEngine.reset()
		
		var audioPlayerNode = AVAudioPlayerNode()
		audioEngine.attachNode(audioPlayerNode)
		
		var changePitchEffect = AVAudioUnitTimePitch()
		changePitchEffect.pitch = pitch
		audioEngine.attachNode(changePitchEffect)
		
		audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
		audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
		
		audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
		audioEngine.startAndReturnError(nil)
		
		stop_button.hidden = false
		audioPlayerNode.play()
	}
	
	@IBAction func stopPlayback(sender: UIButton) {
		audioPlayer.stop()
		audioPlayer.currentTime = 0.0
		audioEngine.stop()
		audioEngine.reset()
		stop_button.hidden = true

	}
	@IBAction func playFast(sender: UIButton) {
		audioEngine.stop()
		audioEngine.reset()
		audioPlayer.stop()
		audioPlayer.currentTime = 0.0
		audioPlayer.rate = 2.0
		stop_button.hidden = false
		audioPlayer.play()
	}
	
	@IBAction func playSlow(sender: UIButton) {
		audioEngine.stop()
		audioEngine.reset()
		audioPlayer.stop()
		audioPlayer.currentTime = 0.0
		audioPlayer.rate = 0.5
		stop_button.hidden = false
		audioPlayer.play()
	}
}
