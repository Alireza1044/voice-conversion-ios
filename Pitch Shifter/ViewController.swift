//
//  ViewController.swift
//  Pitch Shifter
//
//  Created by Alireza Moradi on 7/26/20.
//  Copyright © 2020 Alireza Moradi. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit

class ViewController: UIViewController {
    
//    var player : AVAudioPlayerNode!
//    var timePitch : AVAudioUnitTimePitch!
//    var engine : AVAudioEngine!
//    var a : AVAudioSession!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    var micBooster: AKBooster?
    var pitchShifter: AKPitchShifter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
        let mic = AKMicrophone()

        let micMixer = AKMixer(mic)

        micBooster = AKBooster(micMixer)

        pitchShifter = AKPitchShifter(micBooster, shift: 0)

        micBooster!.gain = 5

        AudioKit.output = pitchShifter

        do{
            try AudioKit.start()
        } catch {
            print("error occured")
        }
    }
    
    @IBAction func onSliderChanged(_ sender: Any) {
        label.text = "Shift Amount: \(Int(slider.value))"
        pitchShifter?.shift = Double(Int(slider.value))
    }
    
    
}

