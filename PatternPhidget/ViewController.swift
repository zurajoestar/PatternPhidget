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
    @IBOutlet weak var scoreLabel: UILabel!
    
    let buttonArray = [DigitalInput(), DigitalInput()]
    let ledArray = [DigitalOutput(), DigitalOutput()]
    
    let allPatterns = patternsss()
    var questionPatternNumber : Int = 0
    var score : Int = 0
    var pickedAnswer1 : Bool = false
    var pickedAnswer2 : Bool = false
    var pickedAnswer3 : Bool = false
    var pickedAnswer4 : Bool = false
    var patternNumberTracker: Int = 0
    
    
    
    
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
    
    func state_change_button_Green(sender:DigitalInput, state:Bool){
        do{
            
            
            
            
            
            if(state == true && patternNumberTracker == 0){
                pickedAnswer1 = true
                try ledArray[1].setState(true)
                checkAnswer1()
                patternNumberTracker = 1
            }
                
            else if (state == true && patternNumberTracker == 1) {
                pickedAnswer2 = true
                try ledArray[1].setState(true)
                checkAnswer2()
                patternNumberTracker = 2
            }
            else if (state == true && patternNumberTracker == 2) {
                pickedAnswer3 = true
                try ledArray[1].setState(true)
                checkAnswer3()
                patternNumberTracker = 3
            }
            else if (state == true && patternNumberTracker == 3) {
                pickedAnswer4 = true
                try ledArray[1].setState(true)
                checkAnswer4()
                patternNumberTracker = 0
                questionPatternNumber += 1
                nextPattern()
            }
            else{
                try ledArray[1].setState(false)
                
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    func state_change_button_Red(sender:DigitalInput, state:Bool){
        do{
            
            if(state == true && patternNumberTracker == 0){
                pickedAnswer1 = false
                try ledArray[1].setState(true)
                checkAnswer1()
                patternNumberTracker = 1
            }
                
            else if (state == true && patternNumberTracker == 1) {
                pickedAnswer2 = false
                try ledArray[1].setState(true)
                checkAnswer2()
                patternNumberTracker = 2
            }
            else if (state == true && patternNumberTracker == 2) {
                pickedAnswer3 = false
                try ledArray[1].setState(true)
                checkAnswer3()
                patternNumberTracker = 3
            }
            else if (state == true && patternNumberTracker == 3) {
                pickedAnswer4 = false
                try ledArray[1].setState(true)
                checkAnswer4()
                patternNumberTracker = 0
                questionPatternNumber += 1
                nextPattern()
            }
            
            else{
                try ledArray[0].setState(false)
                
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let firstPattern = self.allPatterns.list[0]
            self.patternLabel.text = firstPattern.patternSequence
        }
    
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
            let _ = buttonArray[0].stateChange.addHandler(state_change_button_Red)
            let _ = buttonArray[1].stateChange.addHandler(state_change_button_Green)
            
            
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //other errors here
        }
    }

   
    func nextPattern() {
        
        
        
        if questionPatternNumber < 4 {
            DispatchQueue.main.async {
                self.patternLabel.text = self.allPatterns.list[self.questionPatternNumber].patternSequence
                self.scoreLabel.text = ("Score: \(self.score)")
            }
        }
            
        else {
            
            DispatchQueue.main.async {
                self.instructionLabel.text = "Done!"
                self.patternLabel.text = ""
            }
            
            let alert = UIAlertController(title: "Great job!", message: "You have finished the game! Do you want to start over?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction (title: "Restart", style: .default, handler: { (UIAlertAction) in
                self.startOver()
            })
            
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
        
        }
    }
    
    func startOver () {
        questionPatternNumber = 0
        score = 0
        nextPattern()
    }
        
        
    func checkAnswer1() {
        
        let correctAnswer1 = allPatterns.list[questionPatternNumber].answer1
        
        if (pickedAnswer1 == correctAnswer1) {
            print ("1 correct")
        }
        else {
            print("1 wrong")
            
        }
    }
        
    func checkAnswer2() {
        let correctAnswer2 = allPatterns.list[questionPatternNumber].answer2
        if (pickedAnswer2 == correctAnswer2) {
            print ("2 correct")
        }
        else {
            print("2 wrong")
            
        }
    }
            
    func checkAnswer3() {
        let correctAnswer3 = allPatterns.list[questionPatternNumber].answer3
        if (pickedAnswer3 == correctAnswer3) {
            print ("3 correct")
        }
        else {
            print("3 wrong")
            
        }
    }
                
    func checkAnswer4() {

        let correctAnswer1 = allPatterns.list[questionPatternNumber].answer1
        let correctAnswer2 = allPatterns.list[questionPatternNumber].answer2
        let correctAnswer3 = allPatterns.list[questionPatternNumber].answer3
        let correctAnswer4 = allPatterns.list[questionPatternNumber].answer4
        
        if (pickedAnswer4 == correctAnswer4) {
            print ("4 correct")
        }
        else {
            
            print("4 wrong")
            
            }
    

        
        if (pickedAnswer1 == correctAnswer1 && pickedAnswer2 == correctAnswer2 && pickedAnswer3 == correctAnswer3 && pickedAnswer4 == correctAnswer4) {
//        if (correctAnswer1 == pickedAnswer1 && correctAnswer2 == pickedAnswer2 && correctAnswer3 == pickedAnswer3 && correctAnswer4 == pickedAnswer4) {
            DispatchQueue.main.async {
                self.instructionLabel.text = "Correct!"
            }
            score = score + 1
            print("correct")
        }
            
        else {
            print("no score lol")
            DispatchQueue.main.async {
                self.instructionLabel.text = "Wrong!"
            }
        }
        
        
    }
    

    
}


