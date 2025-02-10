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
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let apiKey = Bundle.main.weatherKey
    
    private lazy var defaultQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "appid", value: self.apiKey),
        URLQueryItem(name: "units", value: "metric")
    ]

    private init(){}
    
    // URL 생성
    private func makeURL(endpoint: String, queryItems: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents(string: baseURL + endpoint)
        urlComponents?.queryItems = defaultQueryItems + queryItems
        return urlComponents?.url
    }
    
    // MARK: - Fetch Current Weather Data
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeatherResult, Error>) -> Void) {
        
        let additionalQueryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        
        // URL 생성
        guard let url = makeURL(endpoint: "weather", queryItems: additionalQueryItems) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
        // Alamofire 요청
        AF.request(url, method: .get).responseDecodable(of: CurrentWeatherResult.self) { response in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Fetch Hourly Weather Data
    func fetchHourlyWeather(lat: Double, lon: Double, completion: @escaping (Result<HourlyWeatherResult, Error>) -> Void) {
        
        let additionalQueryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        
        guard let url = makeURL(endpoint: "forecast", queryItems: additionalQueryItems) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        AF.request(url, method: .get).responseDecodable(of: HourlyWeatherResult.self) { response in
            switch response.result {
            case .success(let hourlyData):
                completion(.success(hourlyData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
