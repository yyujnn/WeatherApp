//
//  HourlyWeatherResult.swift
//  WeatherApp
//
//  Created by 정유진 on 1/23/25.
//

import Foundation

struct HourlyWeatherResult: Codable {
    let list: [HourlyWeather]
}

struct HourlyWeather: Codable {
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
