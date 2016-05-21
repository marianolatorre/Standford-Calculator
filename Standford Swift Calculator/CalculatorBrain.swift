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
    
    func setOperant(operand: Double) {
        accumulator = operand
    }
    
    private var pendingBinaryOp : PendingBinaryOperation?
    
    func performOperation (symbol: String) {
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
        }
    
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
    
    func reset () {
        pendingBinaryOp = nil
        accumulator = 0.0
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }

}