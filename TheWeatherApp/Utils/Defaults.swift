//
//  Defaults.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import Foundation

final class Defaults {
    static var shared = Defaults()
    private let defaults = UserDefaults.standard
    
    //MARK: Keys
    private let lastSearchedCityKey = "lastSearchedCityKey"
    
    //MARK: Methods
    var lastSearchedCity: String? {
        get {
            defaults.string(forKey: lastSearchedCityKey)
        }
        set {
            defaults.set(newValue, forKey: lastSearchedCityKey)
        }
    }
}
