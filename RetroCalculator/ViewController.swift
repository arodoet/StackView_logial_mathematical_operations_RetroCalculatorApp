//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Vuk Knežević on 1/7/19.
//  Copyright © 2019 Teodora Knežević. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var outputLbl: UILabel!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    var btnSound:AVAudioPlayer!
    
    enum Operation:String{
        case Add = "+"
        case Subtract = "-"
        case Divide = "/"
        case Multuply = "*"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath:path!)
        
        do{
           try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
    }
    
    @IBAction func numberPressed(sender:UIButton){
        playSound()
        runningNumber+="\(sender.tag)"
        outputLbl.text = runningNumber
    }

    func playSound(){
        if btnSound.isPlaying{
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation:Operation){
        
        playSound()
        
        if currentOperation == Operation.Empty{     // ovo je 1.put kada je operator pritisnut
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
        if currentOperation != Operation.Empty{
            
            //Korisnik je selektovao operator, ali onda je selektovao drugi operator,umesto da je ukucao broj
            //npr. pritisnuo + pa posle odmah pritisnuo * E tada je runningNumber = "" . Zato je stavio ovaj if
            if runningNumber != ""{
                
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Add{
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                if currentOperation == Operation.Subtract{
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                }
                if currentOperation == Operation.Divide{
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                }
                if currentOperation == Operation.Multuply{
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = operation
        }
    }
    
    @IBAction func onDividePressed(sender:Any){
        processOperation(operation: Operation.Divide)
    }

    @IBAction func onMultipyPressed(sender:Any){
        processOperation(operation: Operation.Multuply)
    }
    @IBAction func onAddPressed(sender:Any){
        processOperation(operation: Operation.Add)
    }
    @IBAction func onSubtractPressed(sender:Any){
        processOperation(operation: Operation.Subtract)
    }
    @IBAction func onEqualPressed(sender:Any){
        processOperation(operation:currentOperation)
    }
    
    
    @IBAction func onClearPressed(_ sender: Any) {
        
        playSound()
        
        currentOperation = Operation.Empty
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
        result = ""
        outputLbl.text = "0"
        
    }
    
    
}

