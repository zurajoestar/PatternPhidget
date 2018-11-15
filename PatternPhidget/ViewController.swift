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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            //enable server
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            
            //address, add handler, open digital BUTTONS
            for i in 0..<buttonArray.count{
                try buttonArray[i].setDeviceSerialNumber(528040)
                try buttonArray[i].setHubPort(i)
                try buttonArray[i].setIsHubPortDevice(true)
//                let _ = buttonArray[i].attach.addHandler(attach_handler)
                try buttonArray[i].open()
            }
            
            
            //address, add handler, open LEDs
            for i in 0..<ledArray.count{
                try ledArray[i].setDeviceSerialNumber(528040)
                try ledArray[i].setHubPort(i+2)
                try ledArray[i].setIsHubPortDevice(true)
//                let _ = ledArray[i].attach.addHandler(attach_handler)
                try ledArray[i].open()
            }
            
            
            
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //other errors here
        }
    }

    
    func updateUI() {
        patternLabel.text = "ooo"
    }

}

