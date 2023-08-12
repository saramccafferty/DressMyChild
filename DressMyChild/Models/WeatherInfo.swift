//
//  WeatherInfo.swift
//  DressMyChild
//
//  Created by Sara on 23/2/2023.
//

import Foundation

// WeatherInfo struct for weatherbit JSON response
struct WeatherInfo: Codable {
    let cityName: String
    let countryCode: String
    let data: [WeatherData]
    
    // coding keys to map the JSON and WeatherInfo object
    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case countryCode = "country_code"
        case data
    }
    
    // initializer to decode JSON to WeatherInfo object
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cityName = try container.decode(String.self, forKey: CodingKeys.cityName)
        countryCode = try container.decode(String.self, forKey: CodingKeys.countryCode)
        data = try container.decode([WeatherData].self, forKey: CodingKeys.data)
    }
}

// WeatherData struct for weatherbit JSON response
struct WeatherData: Codable {
    let highTemp: Double
    let lowTemp: Double
    let weather: Weather
    
    // coding keys to map the JSON and WeatherData object
    private enum CodingKeys: String, CodingKey {
        case highTemp = "high_temp"
        case lowTemp = "low_temp"
        case weather
    }
    
    // initializer to decode JSON to WeatherData object
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        highTemp = try container.decode(Double.self, forKey: CodingKeys.highTemp)
        lowTemp = try container.decode(Double.self, forKey: CodingKeys.lowTemp)
        weather = try container.decode(Weather.self, forKey: CodingKeys.weather)
    }
    
    // Weather struct for weatherbit JSON response
    struct Weather: Codable {
        let icon: String
        let description: String
    }
}

