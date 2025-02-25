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
    let main: WeatherMain
    let weather: [Weather]
    
    var dtDate: Date? {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }
    
    var kstDate: Date? {
        return Date(timeIntervalSince1970: TimeInterval(dt)).toKST()
    }
    
    var kstString: String? {
        return dtDate?.summary
    }
    
    var kstTime: String? {
        return dtDate?.shortTime
    }
}

struct DailyWeather {
    let day: String   // "yyyy-MM-dd"
    let minTemp: Int
    let maxTemp: Int
    let weatherIcon: String
}
