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
    let main: WeatherMain
    let weather: [Weather]
}
