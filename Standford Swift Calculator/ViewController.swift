//
//  ViewController.swift
//  Standford Swift Calculator
//
//  Created by mariano latorre on 21/05/2016.
//  Copyright © 2016 mariano latorre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMidleOfTyping : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    @IBAction private func resetStatus(sender: UIButton) {
        userIsInTheMidleOfTyping = false
        displayValue = 0
        brain = CalculatorBrain()
    }
    
    @IBAction private func digitPressed(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMidleOfTyping {
            let currentNumber = display.text!
            display.text = currentNumber + digit
        }else{
            display.text = digit
        
        }
        userIsInTheMidleOfTyping = true
    }

    private var brain = CalculatorBrain()
    
    @IBAction private func operationButtonPressed(sender: UIButton) {
        
        if userIsInTheMidleOfTyping {
            brain.setOperant(displayValue)
            userIsInTheMidleOfTyping = false
        }
        
        if let operation = sender.currentTitle {
            brain.performOperation(operation)
        }
        
        displayValue = brain.result
    }
}

