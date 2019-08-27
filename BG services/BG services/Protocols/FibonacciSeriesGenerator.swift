//
//  FibonacciSeriesGenerator.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

protocol FibonacciSeriesGeneratorProtocol {
    var previous: NSDecimalNumber { get set }
    var current: NSDecimalNumber { get set }
    var position: UInt { get set }
    
    mutating func nextNumber() -> (result: NSDecimalNumber, position: UInt)
    mutating func reset()
}

extension FibonacciSeriesGeneratorProtocol {
    mutating func reset() {
        previous = .one
        current = .one
        position = 1
    }
    
    mutating func nextNumber() -> (result: NSDecimalNumber, position: UInt) {
        let result = current.adding(previous)
        previous = current
        current = result
        position += 1
        return (result, position)
    }
}

class FibonacciSeriesGenerator: FibonacciSeriesGeneratorProtocol {
    
    var previous: NSDecimalNumber
    
    var current: NSDecimalNumber
    
    var position: UInt
    
    init() {
        previous = .one
        current = .one
        position = 1
    }
}
