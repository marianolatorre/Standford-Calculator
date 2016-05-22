//
//  CalculatorBrain.swift
//  Standford Swift Calculator
//
//  Created by mariano latorre on 21/05/2016.
//  Copyright © 2016 mariano latorre. All rights reserved.
//

import Foundation


class CalculatorBrain{

    private var accumulator : Double = 0.0
    private var internalProgram = [AnyObject]()
    private var variableNames = Dictionary<String,Double>()
    
    func setVariableValue (variableName :String, variableValue: Double) {
        variableNames[variableName] = variableValue
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func setOperand(operand: String) {
        accumulator = variableNames[operand] ?? 0.0
        internalProgram.append(operand)
    }
    
    private var pendingBinaryOp : PendingBinaryOperation?
    
    func performOperation (symbol: String) -> Bool{
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function):
                processPendingOperation()
                pendingBinaryOp = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                processPendingOperation()
            }
            return true;
        }
        
        return false;
    }

    private func processPendingOperation () {
        if let op = pendingBinaryOp {
            accumulator = op.binaryFunction(op.firstOperand, accumulator)
            pendingBinaryOp = nil
        }
    }
    
    private var operations : Dictionary<String, Operation> = [
        "∏" : Operation.Constant(M_PI),
        "℮" : Operation.Constant(M_E),
        "√": Operation.UnaryOperation( sqrt ),
        "cos": Operation.UnaryOperation( cos ),
        "sin": Operation.UnaryOperation( sin ),
        "tan": Operation.UnaryOperation( tan ),
        "log10": Operation.UnaryOperation( log10 ),
        "log": Operation.UnaryOperation( log ),
        "±": Operation.UnaryOperation( { -$0} ),
        "+": Operation.BinaryOperation( {$0 + $1} ),
        "-": Operation.BinaryOperation( {$0 - $1}),
        "×": Operation.BinaryOperation( {$0 * $1}),
        "÷": Operation.BinaryOperation( {$0 / $1}),
        "=": Operation.Equals
    ]
    
    private enum Operation  {
        case Constant (Double)
        case UnaryOperation( (Double) -> (Double) )
        case BinaryOperation( (Double, Double) -> Double )
        case Equals
    }
    
    private struct PendingBinaryOperation {
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    
    
    var program : PropertyList {
        get{
            return internalProgram
        }
        set {
            reset()
            
            if let arrayOps = newValue as? [AnyObject] {
                
                for step in arrayOps {
                    if let number = step as? Double {
                        setOperand(number)
                    }else if let op = step as? String {
                        if !performOperation(op) {
                            setOperand(op)
                        }
                    }
                }
                
            }
            
        }
    
    }
    
    func reset () {
        pendingBinaryOp = nil
        accumulator = 0.0
        internalProgram.removeAll()
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }

}