//
//  HomeVC.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {

    //MARK: IBoutlets
    @IBOutlet weak var weatherTemperatureIcon: UIImageView!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var todayLowestTemperatureLabel: UILabel!
    @IBOutlet weak var weatherTemperatureLabel: UILabel!
    @IBOutlet weak var todayHighestTemperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView! {
//        didSet {
//            collectionView.delegate = self
//            collectionView.dataSource = self
//            collectionView.registerCell(type: WeatherCollectionCell.self)
//        }
//    }
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }
    @IBOutlet weak var searchBar: UIView!
    
    //MARK: Private Variables
    private var viewModel = HomeViewModel()
    private var locationManager = CLLocationManager()
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initActions()
        initLocationManager()
        getWeatherDetails()
    }
    
    //MARK: Private Methods
    private func initActions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
    }
    
    private func getWeatherDetails() {
        if let lastCitySearched = Defaults.shared.lastSearchedCity, lastCitySearched != "" {
            getWeatherByCity(cityName: lastCitySearched)
            
        } else {
            getLocation()
        }
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func getLocation() {
        locationManager.requestLocation()
    }
    
    private func setData() {
        let weather = viewModel.weatherDetails
        
        cityNameLabel.text = weather?.cityName
        weatherTemperatureIcon.sd_setImage(with: weather?.weather.first?.iconUrl)
        weatherTemperatureLabel.text = "\(Int(weather?.main.temp ?? 0))"
        feelsLikeTemperatureLabel.text = "Feels like \(Int(weather?.main.feelsLike ?? 0))°"
        todayLowestTemperatureLabel.text = "\(Int(weather?.main.tempMin ?? 0))"
        todayHighestTemperatureLabel.text = "\(Int(weather?.main.tempMax ?? 0))"
        weatherDescriptionLabel.text = weather?.weather.first?.main
    }
    
    private func setSearchBarHidden(_ hide: Bool) {
        UIView.transition(with: searchBar, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.searchBar.isHidden = hide
            
        }) { _ in
            if !hide {
                self.searchField.becomeFirstResponder()
                
            } else {
                self.searchField.resignFirstResponder()
            }
        }
    }

    //MARK: Button Actions
    @IBAction func searchButtonTapped(_ sender: Any) {
        setSearchBarHidden(false)
    }
}

//MARK: UITextFieldDelegate
extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setSearchBarHidden(true)
        
        if let cityName = textField.text?.trim, cityName != "" {
            getWeatherByCity(cityName: cityName)
        }
        
        return false
    }
}

//MARK: CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = Double(location.coordinate.latitude)
            let longitude = Double(location.coordinate.longitude)
            
            getWeatherByLatLong(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}


//MARK: API Calls
extension HomeVC {
    private func getWeatherByCity(cityName: String) {
        showActivityIndicator()
        
        viewModel(.getWeatherByCity(cityName: cityName))
        viewModel.getWeatherDetailsCallback = { [weak self] in
            guard let self else { return }
            self.removeActivityIndicator()
//            self.getHourlyWeather()
            self.setData()
        }
        
        viewModel.errorCallback = { [weak self] message in
            guard let self = self else {return}
            self.removeActivityIndicator()
            self.alert(message)
        }
    }
    
    private func getWeatherByLatLong(latitude: Double, longitude: Double) {
        showActivityIndicator()
        
        viewModel(.getWeatherByLatLong(latitude: latitude, longitude: longitude))
        viewModel.getWeatherDetailsCallback = { [weak self] in
            guard let self else { return }
            self.removeActivityIndicator()
//            self.getHourlyWeather()
            self.setData()
        }
        
        viewModel.errorCallback = { [weak self] message in
            guard let self = self else {return}
            self.removeActivityIndicator()
            self.alert(message)
        }
    }
    
//    private func getHourlyWeather() {
//
//        viewModel(.getHourlyWeather)
//        viewModel.getHourlyWeatherCallback = { [weak self] in
//            guard let self else { return }
//            self.collectionView.reloadData()
//        }
//
//        viewModel.errorCallback = { [weak self] message in
//            guard let self = self else {return}
//            self.alert(message)
//        }
//    }
}

//extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.hourlyWeather?.count == 0 ? 0 : 24
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueCell(withType: WeatherCollectionCell.self, for: indexPath) as! WeatherCollectionCell
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 80, height: collectionView.frame.height)
//    }
//}
