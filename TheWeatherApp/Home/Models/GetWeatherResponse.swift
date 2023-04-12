//
//  GetLatLongResponse.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import Foundation

struct GetWeatherResponse: Codable {
    let coordinates: Coordinate
    let weather: [Weather]
    let main: Main
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case weather, main
        case coordinates = "coord"
        case cityName = "name"
    }
}

struct Coordinate: Codable {
    let latitude, longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Weather: Codable {
    let main, icon: String
    
    var iconUrl: URL? {
        URL(string: "\(NetworkConstants.iconUrl)\(icon)@2x.png")
    }
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
}
