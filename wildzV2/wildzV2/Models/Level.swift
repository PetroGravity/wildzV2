//
//  Level.swift
//  wildzV2
//
//  Created by Mac on 17.11.2021.
//

import Foundation

class Level {
    
    static let shared = Level()
    
    var level: Int {
        get {
            return UserDefaults.standard.integer(forKey: "LEVEL")
        }
        set {
            guard newValue > 0 else { return }
            UserDefaults.standard.set(newValue, forKey: "LEVEL")
        }
    }
    
    init() {
        UserDefaults.standard.register(defaults: ["LEVEL" : 1])
    }
}
