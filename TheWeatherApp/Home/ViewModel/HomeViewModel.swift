//
//  HomeViewModel.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import Foundation

class HomeViewModel {
    //MARK: Callbacks
    var errorCallback: ((String) -> Void)?
    var getWeatherDetailsCallback: (() -> Void)?
    var getHourlyWeatherCallback: (() -> Void)?
    
    //MARK: Variables
    var weatherDetails: GetWeatherResponse?
    var hourlyWeather: [GetWeatherResponse]?
    
    //MARK: - Action
    func callAsFunction(_ action: HomeActions) {
        switch action {
        case .getWeatherByCity(let cityName): getWeatherByCity(cityName)
        case .getWeatherByLatLong(let latitude, let longitude): getWeatherByLatLong(latitude, longitude)
        case .getHourlyWeather: getHourlyWeather()
        }
    }
    
    //MARK: Private Variables
    private let session = URLSession(configuration: .default)
    
    //MARK: Get BookingHistory
    private func getWeatherByCity(_ cityName: String) {
        let api = APIService.getWeatherByCity(cityName)
        let router = APIRouter<GetWeatherResponse>(session)
        
        router.request(api) { [weak self] output, statusCode, error in
            guard let self = self else {return}
            
            if let response = output {
                self.weatherDetails = response
                Defaults.shared.lastSearchedCity = response.cityName
                self.getWeatherDetailsCallback?()
                
            } else if let error = error {
                self.errorCallback?(error.localizedDescription)
                
            } else {
                self.errorCallback?("Something went wrong!")
            }
        }
    }
    
    private func getWeatherByLatLong(_ latitude: Double, _ longitude: Double) {
        let api = APIService.getWeatherByLatLong(latitude, longitude)
        let router = APIRouter<GetWeatherResponse>(session)
        
        router.request(api) { [weak self] output, statusCode, error in
            guard let self = self else {return}
            
            if let response = output {
                self.weatherDetails = response
                Defaults.shared.lastSearchedCity = response.cityName
                self.getHourlyWeather()
                
            } else if let error = error {
                self.errorCallback?(error.localizedDescription)
                
            } else {
                self.errorCallback?("Something went wrong!")
            }
        }
    }
    
    private func getHourlyWeather() {
        let api = APIService.getHourlyWeather(weatherDetails?.coordinates.latitude ?? 0, weatherDetails?.coordinates.longitude ?? 0)
        let router = APIRouter<GetHourlyWeatherResponse>(session)
        
        router.request(api) { [weak self] output, statusCode, error in
            guard let self = self else {return}
            
            if let response = output?.list {
                self.hourlyWeather = response
                self.getHourlyWeatherCallback?()
                
            } else if let error = error {
                self.errorCallback?(error.localizedDescription)
                
            } else {
                self.errorCallback?("Something went wrong!")
            }
        }
    }
}
