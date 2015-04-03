//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Padmaja Arekuti on 3/23/15.
//  Copyright (c) 2015 Padmaja Arekuti. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode = AVAudioPlayerNode()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func stopAudio(sender: UIButton) {
        //Stops audio when audio is playing with variable rate.
        if let player = audioPlayer {
             player.stop()
        }
        //Stop audio played at variable pitch.
        audioPlayerNode.stop()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        
        playAudioWithVariableRate(0.5,playTimePos: 0.0)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2.0,playTimePos: 0.0)
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
         playAudioWithVariablePitch(-1000)
    }

    /*
    * This method palys an audio at the specified pitch value.
    */
    func playAudioWithVariablePitch(pitch:Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //Step 2: Create AVAudioPlayerNode object and attach to AVAudioEngine
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Step 3: Create AVAudioUnitTimePitch object and attach to AVAudioEngine
        var chagePitchEffect = AVAudioUnitTimePitch()
        chagePitchEffect.pitch = pitch
        audioEngine.attachNode(chagePitchEffect)
        
        //Step 4: Connect AVAudioPlayerNode to AVAudioUnitTimePitch
        audioEngine.connect(audioPlayerNode, to: chagePitchEffect, format: nil)
        
        //Step 5: connect AVAudioUnitTimePitch to output
        audioEngine.connect(chagePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    /*
    * This method plays an audio at the specified rate and from specified position.
    */
    func playAudioWithVariableRate(playRate: Float, playTimePos:Double){
        
        if let player = audioPlayer {
            player.stop()
            audioEngine.stop()
            audioEngine.reset()
            player.rate = playRate
            player.currentTime = playTimePos
            player.play()
        }

    }
}
