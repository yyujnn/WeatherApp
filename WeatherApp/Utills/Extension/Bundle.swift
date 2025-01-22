//
//  Bundle.swift
//  WeatherApp
//
//  Created by 정유진 on 1/14/25.
//

import Foundation

// API KEY, URL 관리 Extension
extension Bundle {
    
    // OpenWeatherMap API Key
    var weatherKey: String{
        guard let filePath = Bundle.main.path(forResource: "OpenWeatherInfo", ofType: "plist") else{
            fatalError("Couldn't find file 'OpenWeatherInfo.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "WeatherAPIKey") as? String else{
            fatalError("Couldn't find key 'WeatherAPIKey' in 'OpenWeatherInfo.plist'.")
        }
        
        return value
    }
}
