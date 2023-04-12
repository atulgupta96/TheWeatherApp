//
//  HomeActions.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import Foundation

enum HomeActions {
    case getWeatherByCity(cityName: String)
    case getWeatherByLatLong(latitude: Double, longitude: Double)
    case getHourlyWeather
}
