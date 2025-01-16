//
//  WeatherAPIManager.swift
//  WeatherApp
//
//  Created by 정유진 on 1/15/25.
//

import Alamofire
import Foundation

class WeatherAPIManager {
    
    static let shared = WeatherAPIManager()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = Bundle.main.weatherKey

    private init(){}
    
    // MARK: - Generic Fetch
    
}
