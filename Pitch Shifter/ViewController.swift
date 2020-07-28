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
import AudioKitUI
import EZAudio


class ViewController: UIViewController {
    
//    var player : AVAudioPlayerNode!
//    var timePitch : AVAudioUnitTimePitch!
//    var engine : AVAudioEngine!
//    var a : AVAudioSession!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var audioInputPlot: AKNodeOutputPlot!
    
    var micBooster: AKBooster?
    var pitchShifter: AKPitchShifter?
    var tracker: AKFrequencyTracker!
    let mic = AKMicrophone()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
        

        let micMixer = AKMixer(mic)
        tracker = AKFrequencyTracker.init(mic)
        micBooster = AKBooster(micMixer)

        pitchShifter = AKPitchShifter(micBooster, shift: 0)

        micBooster!.gain = 5

        AudioKit.output = pitchShifter

        do{
            try AudioKit.start()
        } catch {
            print("error occured")
        }
        setupPlot()
    }
    
    func setupPlot() {
        let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.blue
        audioInputPlot.addSubview(plot)
    }

    
    @IBAction func onSliderChanged(_ sender: Any) {
        label.text = "Shift Amount: \(Int(slider.value))"
        pitchShifter?.shift = Double(Int(slider.value))
    }
    
    
}

