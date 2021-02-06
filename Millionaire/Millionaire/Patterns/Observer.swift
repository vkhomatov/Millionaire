//
//  Observer.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 16.05.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

class ClosureObservable {
    
    var gameTime: Int {
        didSet {
            observers.forEach { $0(gameTime) }
        }
    }
    
    private var observers: [(Int) -> Void] = []
    
    init(gameTime: Int) {
        self.gameTime = gameTime
    }
    
    public func observe(_ observationClosure: @escaping (Int) -> Void) {
        observers.append(observationClosure)
    }
}
