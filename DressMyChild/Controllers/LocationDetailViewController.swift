//
//  LocationDetailViewController.swift
//  DressMyChild
//
//  Created by Sara on 16/2/2023.
//

import UIKit
import CoreLocation

class LocationDetailViewController: UIViewController {
    
    let api = API()
    var location: Location?
    let shape = CAShapeLayer()
    
    // property to hold the adjusted temperature, which triggers the recommendation update when set
    var adjustedTemp: Double = 0 {
        didSet {
            updateClothingRecommendation()
        }
    }
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var clothingLabel: UILabel!
    @IBOutlet var clothingThicknessLabel: UILabel!
    @IBOutlet var clothingImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load the weather data for the given location
        if let location = location {
            loadData(location: location)
        }
        
        // set loading animation properties
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        shape.path = circlePath.cgPath
        shape.lineWidth = 25
        shape.strokeColor = UIColor.systemTeal.withAlphaComponent(0.7).cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        view.layer.addSublayer(shape)
    }
    
    // function for the loading animation
    func loadingAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1
        shape.add(animation, forKey: "animation")
    }
    
    // load weather API response data
    func loadData(location: Location) {
        // trigger the animation
        loadingAnimation()
        // call API to fetch weather information
        api.fetchWeatherInfo(location: location) { [weak self] result in
            // if the API request is successful update UI with the returned data. If not print error message
            switch result {
            case let .success(info):
                self?.updateUI(with: info)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // update UI with fetched weather data
    func updateUI(with info: WeatherInfo) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = "\(info.cityName), \(info.countryCode)"
            if let weatherData = info.data.first {
                self.descriptionLabel.text = weatherData.weather.description
                self.highTempLabel.text = "High: " + String(weatherData.highTemp) + "°C"
                self.lowTempLabel.text = "Low: " + String(weatherData.lowTemp) + "°C"
                self.iconImageView.image = UIImage(named: weatherData.weather.icon)
                self.adjustedTemp = Double(weatherData.lowTemp) + Double(self.location?.indoorTempVariance ?? 5)
            } else {
                // if no weather data available update UI with unavailable message and no info
                self.descriptionLabel.text = "No weather data available"
                self.highTempLabel.text = "N/A"
                self.lowTempLabel.text = "N/A"
                self.iconImageView.image = nil
                self.adjustedTemp = 0
            }
        }
    }
    
    // update the UI with clothing information based on the adjusted indoor temp (low temp + user determined indoor temp variance)
    func updateClothingRecommendation() {
        switch adjustedTemp {
        case ..<7:
            clothingThicknessLabel.text = "Consider adding blankets"
            clothingThicknessLabel.textColor = .systemRed
            clothingLabel.text = "Warm onsie / flannelette pants and long sleeve top + fleece tracksuit + socks + singlet / bodysuit"
            clothingImageView.image = UIImage(named: "Tracksuit")
        case 7..<12:
            clothingThicknessLabel.text = "Flannelette + fleece thickness"
            clothingLabel.text = "Warm onsie / flannelette pants and long sleeve top + fleece tracksuit + socks + singlet / bodysuit"
            clothingImageView.image = UIImage(named: "Tracksuit")
        case 12..<18:
            clothingThicknessLabel.text = "Flannelette thickness"
            clothingLabel.text = "Warm onesie / flannelette pants and long sleeve top + socks + singlet / bodysuit"
            clothingImageView.image = UIImage(named: "Flannelette")
        case 18..<21:
            clothingThicknessLabel.text = "Standard T-shirt thickness"
            clothingLabel.text = "Onesie / long pants and long shirt socks + socks"
            clothingImageView.image = UIImage(named: "Long with socks")
        case 21..<24:
            clothingThicknessLabel.text = "Standard T-shirt thickness"
            clothingLabel.text = "Short sleeve onesie / long pants and shortsleeved shirt"
            clothingImageView.image = UIImage(named: "Pant Shirt")
        case 24..<27:
            clothingThicknessLabel.text = "Standard T-shirt thickness"
            clothingLabel.text = "Romper / shorts + shortsleeved shirt"
            clothingImageView.image = UIImage(named: "Shorts")
        case 27..<30:
            clothingThicknessLabel.text = "Lightweight and breathable"
            clothingLabel.text = "Singlet / bodysuit"
            clothingImageView.image = UIImage(named: "Singlet")
        case 30...:
            clothingThicknessLabel.text = "No clothing"
            clothingLabel.text = "Underwear / nappy"
            clothingImageView.image = UIImage(named: "Nappy")
        default:
            clothingThicknessLabel.text = "Error"
            clothingLabel.text = "Error"
            clothingImageView.image = UIImage(named: "default")
        }
    }
}



