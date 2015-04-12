//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Timothy T Sanders on 4/3/15.
//  Copyright (c) 2015 udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet weak var recordingInProgress: UILabel!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var recordButton: UIButton!
	
	var audioRecorder:AVAudioRecorder!
	var recordedAudio: RecordedAudio!
	var filePath = NSURL()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		recordingInProgress.text = "Tap to Record"
		stopButton.hidden = true
	}

	override func viewWillAppear(animated: Bool) {
		recordButton.enabled = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	@IBAction func recordAudio(sender: UIButton) {
		// TODO: Show text "recording in progress"
		// TODO: Record the user's voice
		recordingInProgress.text = "Recording in Progress"
		stopButton.hidden = false
		recordButton.enabled = false
		println("in recordAudio")
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
		
		let currentDateTime = NSDate()
		let formatter = NSDateFormatter()
		formatter.dateFormat = "ddMMyyyy-HHmmss"
		let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
		let pathArray = [dirPath, recordingName]
		filePath = NSURL.fileURLWithPathComponents(pathArray)!
		println(filePath.lastPathComponent)
		
		// set up audio sessioon
		var session = AVAudioSession.sharedInstance()
		session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
		// initialize and prepare the recorder
		audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
		audioRecorder.delegate = self
		audioRecorder.meteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
		
	}
	
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
		
		if (flag) {
			if (self.filePath.lastPathComponent != nil) {
				self.recordedAudio = RecordedAudio(filePathUrl: self.filePath, title: self.filePath.lastPathComponent!)
			} else {
				self.recordedAudio = RecordedAudio(filePathUrl: self.filePath, title: "No Title")
			}
			self.performSegueWithIdentifier("stopRecording", sender: self.recordedAudio)
		} else {
			println("Recording was not successful.")
			recordButton.enabled = true
			stopButton.hidden = true
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if (segue.identifier == "stopRecording") {
			let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
			let data = sender as RecordedAudio
			playSoundsVC.receivedAudio = data
		}
	}


	@IBAction func stopButton(sender: UIButton) {
		recordingInProgress.text = "Tap to Record"
		stopButton.hidden = true
		audioRecorder.stop()
		var session = AVAudioSession.sharedInstance();
		session.setActive(false, error: nil)
	}
}

