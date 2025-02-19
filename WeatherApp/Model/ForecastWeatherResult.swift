//
//  ForecastWeatherResult.swift
//  WeatherApp
//
//  Created by 정유진 on 10/4/24.
//

import Foundation

struct ForecastWeatherResult: Codable {
    let list: [ForecastWeather] // 여러 개의 날씨 데이터 (시간별 또는 일별)
}

struct ForecastWeather: Codable {
    let dt: Int
    let dtTxt: String
    let main: WeatherMain
    let weather: [Weather]
    
    var date: Date? {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }
    
    enum CodingKeys: String, CodingKey {
        case dt
        case dtTxt = "dt_txt"
        case main
        case weather
    }
}
