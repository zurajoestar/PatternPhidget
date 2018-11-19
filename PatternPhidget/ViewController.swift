//
//  ViewController.swift
//  PatternPhidget
//
//  Created by Cristina Lopez on 2018-11-15.
//  Copyright © 2018 Cristina Lopez. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var patternLabel: UILabel!
    
    let buttonArray = [DigitalInput(), DigitalInput()]
    let ledArray = [DigitalOutput(), DigitalOutput()]
    
    let allPatterns = patternsss()
    
    
    
    //ATTACH HANDLER
    
    func attach_handler(sender: Phidget){
        do{
            
            let hubPort = try sender.getHubPort()
            
            if(hubPort == 0){
                print("Button 0 Attached")
            }
            else if (hubPort == 1){
                print("Button 1 Attached")
            }
            else if (hubPort == 2){
                print("LED 2 Attached")
            }
            else{
                print("LED 3 Attached")
            }
            
        } catch let err as PhidgetError{
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    
    //STATE CHANGE FUNCTIONS
    func state_change_button0(sender:DigitalInput, state:Bool){
        do{
            if(state == true){
                
                print("Red Button Pressed")
                try ledArray[0].setState(true)
                DispatchQueue.main.async {
                    let firstPattern = self.allPatterns.list[1]
                    self.patternLabel.text = firstPattern.patternSequence
                }

                
            }
            else{
                print("Red Button Released")
                try ledArray[0].setState(false)
                
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    func state_change_button1(sender:DigitalInput, state:Bool){
        do{
            if(state == true){
                    print("Green Button Pressed")
                    try ledArray[1].setState(true)

            }
            else{
                print("Green Button Released")
                try ledArray[1].setState(false)
                
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionLabel.text = "Press red button to start."
    
        do {
            
            //enable server
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            
            //address, add handler, open digital BUTTONS
            for i in 0..<buttonArray.count{
                try buttonArray[i].setDeviceSerialNumber(528040)
                try buttonArray[i].setHubPort(i)
                try buttonArray[i].setIsHubPortDevice(true)
                let _ = buttonArray[i].attach.addHandler(attach_handler)
                try buttonArray[i].open()
            }
            
            
            //address, add handler, open LEDs
            for i in 0..<ledArray.count{
                try ledArray[i].setDeviceSerialNumber(528040)
                try ledArray[i].setHubPort(i+2)
                try ledArray[i].setIsHubPortDevice(true)
                let _ = ledArray[i].attach.addHandler(attach_handler)
                try ledArray[i].open()
            }
            
            //OPENING OBJECTS
            let _ = buttonArray[0].stateChange.addHandler(state_change_button0)
            let _ = buttonArray[1].stateChange.addHandler(state_change_button1)
            
            
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //other errors here
        }
    }

//    func startUp (sender: DigitalInput, state: Bool) {
//
//
//        if (state == true) {
//
//            let firstPattern = allPatterns.list[0]
//            patternLabel.text = firstPattern.patternSequence
//        } else {
//
//        }
//    }
    
    func updateUI() {
        patternLabel.text = "ooo"
    }

    
    func nextPattern() {
        
        
    }
    
    func checkAnswer() {
        
    }
}

