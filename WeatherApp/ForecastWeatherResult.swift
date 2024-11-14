//
//  ForecastWeatherResult.swift
//  WeatherApp
//
//  Created by 정유진 on 10/4/24.
//

import Foundation

struct ForecastWeatherResult: Codable {
    let list: [ForecastWeather]
}

struct ForecastWeather: Codable {
    let main: WeatherMain
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case dtTxt = "dt_txt"
    }
}
