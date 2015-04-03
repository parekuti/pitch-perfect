//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Padmaja Arekuti on 3/17/15.
//  Copyright (c) 2015 Padmaja Arekuti. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var pauseRecordingButton: UIButton!
    @IBOutlet weak var resumeRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        resetElements(true)
        recordingLabel.hidden=false
    }

    /*
    * This method records audio when user taps on microphone image from scene.
    */
    @IBAction func recordAudio(sender: UIButton) {
        //Show text "recording in progress"
        resetElements(false)
        
        //record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //set up audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    @IBAction func pauseRecordAudio(sender: UIButton) {
        pauseRecordingButton.enabled = false
        resumeRecordButton.enabled = true
        recordingLabel.text = "recording paused"
        audioRecorder.pause()
    }
   
    
    @IBAction func resumeRecordAudio(sender: UIButton) {
        pauseRecordingButton.enabled = true
        resumeRecordButton.enabled = false
        recordingLabel.text = "recording in progress"
        audioRecorder.record()
    }
    
    /*
    * This method creates a model object for the recorded audio once the recording is finished.
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            // Step 1: Save the recorded voice
            recordedAudio = RecordedAudio(url: recorder.url,fileTitle: recorder.url.lastPathComponent)
            
            //Step 2: Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            resetElements(false)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier  == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let audioData = sender as RecordedAudio
            playSoundsVC.receivedAudio = audioData
        }
    }
    
    /*
    * This method is invoked when user taps on stop image from scene.
    */
    @IBAction func stopRecordingAudio(sender: UIButton) {
        recordingLabel.hidden=true
        
        //Stop recording audio
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    /*
    * This method enable/disable record, stop buttons and changes text of the label based on isNotRecording flag.
    */
    func resetElements(isNotRecording:Bool){
        if (isNotRecording){
            stopButton.hidden=true
            recordButton.enabled=true
            recordingLabel.text = "Tap to Record"
            pauseRecordingButton.hidden=true
            resumeRecordButton.hidden=true
        }else{
            pauseRecordingButton.hidden=false
            resumeRecordButton.hidden=false
            stopButton.hidden=false
            recordButton.enabled=false
            recordingLabel.text = "recording in progress"
            pauseRecordingButton.enabled = true
            resumeRecordButton.enabled = true
        }
    }

}

