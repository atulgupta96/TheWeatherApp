//
//  WeatherCollectionCell.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import UIKit
import SDWebImage

class WeatherCollectionCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: Methods
    func setupView(icon: String, temperature: String, time: String) {
        weatherIcon.sd_setImage(with: URL(string: "\(NetworkConstants.iconUrl)\(icon)@2x"))
        temperatureLabel.text = "\(temperature)°"
        
    }
}
