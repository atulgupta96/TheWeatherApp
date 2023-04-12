//
//  APIService.swift
//  ProjectMVVM
//
//  Created by Atul Gupta on 04/01/23.
//

import Foundation

enum APIService: Routable {

    case getWeatherByCity(_ cityName: String)
    case getWeatherByLatLong(_ latitude: Double, _ longitude: Double)
    case getHourlyWeather(_ latitude: Double, _ longitude: Double)
    
    var url: URL {
        switch self {
        case .getHourlyWeather:
            return URL(string: "\(NetworkConstants.hourlyWeather)\(endPoint)&appid=\(NetworkConstants.apiKey)&units=metric")!
            
        default:
            return URL(string: "\(NetworkConstants.baseURL)\(endPoint)&appid=\(NetworkConstants.apiKey)&units=metric")!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .GET
        }
    }
    
    var endPoint: String {
        switch self {
        case .getWeatherByCity(let cityName): return "\(NetworkConstants.weather)?q=\(cityName)"
        case .getWeatherByLatLong(let latitude, let longitude): return "\(NetworkConstants.weather)?lat=\(latitude)&lon=\(longitude)"
        case .getHourlyWeather(let latitude, let longitude): return "?lat=\(latitude)&lon=\(longitude)"
        }
    }
    
    var body: Data? {
        switch self {
        default: return nil
        }
    }
    
}
