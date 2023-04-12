//
//  GetHourlyWeatherResponse.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import Foundation

struct GetHourlyWeatherResponse: Codable {
    let list: [GetWeatherResponse]
}
