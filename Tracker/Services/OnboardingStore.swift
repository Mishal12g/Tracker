//
//  FirstLaunch.swift
//  Tracker
//
//  Created by mihail on 22.02.2024.
//

import Foundation

final class OnboardingStore {
    
    static let shared = OnboardingStore()
    
    var isAuth: Bool {
        get {
            UserDefaults.standard.bool(forKey: "auth")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "auth")
        }
    }
    
    private init() {
        let defaults = ["auth": false]
        UserDefaults.standard.register(defaults: defaults)
    }
}
