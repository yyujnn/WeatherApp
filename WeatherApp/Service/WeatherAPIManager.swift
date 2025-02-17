//
//  WeatherAPIManager.swift
//  WeatherApp
//
//  Created by 정유진 on 1/15/25.
//

import Alamofire
import Combine
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
    func fetchCurrentWeather(lat: Double, lon: Double) -> AnyPublisher<CurrentWeatherResult, Error> {
        
        let additionalQueryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        
        guard let url = makeURL(endpoint: "weather", queryItems: additionalQueryItems) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return AF.request(url)
            .publishDecodable(type: CurrentWeatherResult.self)
            .value() // 성공 시 데이터만 반환
            .mapError { $0 as Error } // 에러 처리
            .eraseToAnyPublisher() // 타입 숨기기
    }
    
    // MARK: - Fetch Day Weather Forecast Data
    func fetchForecastWeather(lat: Double, lon: Double) -> AnyPublisher<ForecastWeatherResult, Error> {
        
        let additionalQueryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        
        guard let url = makeURL(endpoint: "forecast", queryItems: additionalQueryItems) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return AF.request(url)
            .publishDecodable(type: ForecastWeatherResult.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
