//
//  API.swift
//  DressMyChild
//
//  Created by Sara on 23/2/2023.
//

import Foundation

final class API {
    let session = URLSession.shared
    
    // function to fetch weather information for Location
    func fetchWeatherInfo(location: Location, completion: @escaping
                          (Result<WeatherInfo, Error>) -> ()) {
        
        // URLRequest object with the Location lon and lat included in parameters for API endpoints
        let request = URLRequest(
            url: "https://api.weatherbit.io/v2.0/forecast/daily",
            queries: ["key": "c52cd557fc9b450e96cba753ae09f09f",
                      "lat": String(location.lat),
                      "lon": String(location.lon),
                      "units": "M",
                      "days": "1"])
        
        session.request(request, completion: completion)
    }
}
