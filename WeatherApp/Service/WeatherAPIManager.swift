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
    
    // URL 쿼리 아이템들.
    private lazy var defaultQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "appid", value: self.apiKey),
        URLQueryItem(name: "units", value: "metric")
    ]

    private init(){}
    
    // URL 생성
    private func makeURL(endpoint: String, additionalQueryItems: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents(string: baseURL + endpoint)
        urlComponents?.queryItems = defaultQueryItems + additionalQueryItems
        return urlComponents?.url
    }
    
    // MARK: - Generic Fetch
    // 제네릭 데이터 요청 메서드
    func fetchData<T: Decodable>(endpoint: String, queryItems: [URLQueryItem], completion: @escaping (T?) -> Void) {
        guard let url = makeURL(endpoint: endpoint, additionalQueryItems: queryItems) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        print("Request URL: \(url.absoluteString)")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("Failed to load data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let successRange = 200..<300
            if let httpResponse = response as? HTTPURLResponse, successRange.contains(httpResponse.statusCode) {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedData)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil)
                }
            } else {
                print("HTTP Response error")
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
                completion(nil)
            }
        }.resume()
    }
}
