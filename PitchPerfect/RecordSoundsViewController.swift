//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Harry  Philip on 4/6/17.
//  Copyright © 2017 Harry  Philip. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonState(enableRecording: true)
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
        recordButton.imageView?.contentMode = .scaleAspectFit
    }

    @IBAction func recordAudio(_ sender: Any) {
        
        setButtonState(enableRecording: false)
        
        //set storage location
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        
        setButtonState(enableRecording: true)
        
        //stop the recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func setButtonState(enableRecording: Bool){
        stopRecordingButton.isEnabled = !enableRecording
        recordButton.isEnabled = enableRecording
        if enableRecording{
            recordingLabel.text = "Tap to Record"
        } else {
            recordingLabel.text = "Recording in Progress"
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }


}

