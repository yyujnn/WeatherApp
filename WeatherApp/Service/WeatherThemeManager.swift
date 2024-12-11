//
//  WeatherThemeManager.swift
//  WeatherApp
//
//  Created by 정유진 on 12/10/24.
//

import Foundation

final class WeatherThemeManager {
    static let shared = WeatherThemeManager() // 싱글톤 패턴
    
    private init() {}
    
    func updateTheme(for weather: String) -> WeatherTheme {
        switch weather {
        case "sunny":
            return WeatherTheme(
                backgroundColor: .sunnyBackground,
                fontColor: .sunnyFont,
                pointColor1: .sunnyPoint1,
                pointColor2: .sunnyPoint2,
                animationName: "sunnyAnimation"
            )
            
        case "cloudy":
            return WeatherTheme(
                backgroundColor: .cloudyBackground,
                fontColor: .appDarkGray,
                pointColor1: .cloudyPoint1,
                pointColor2: .cloudyPoint2,
                animationName: "cloudyAnimation"
            )
            
        case "rainy":
            return WeatherTheme(
                backgroundColor: .rainyBackground,
                fontColor: .appDarkGray,
                pointColor1: .rainyPoint1,
                pointColor2: .rainyPoint2,
                animationName: "rainyAnimation"
            )
            
        case "snowy":
            return WeatherTheme(
                backgroundColor: .snowyBackground,
                fontColor: .snowyFont,
                pointColor1: .snowyPoint1,
                pointColor2: .snowyPoint2,
                animationName: "snowyAnimation"
            )
            
        case "foggy":
            return WeatherTheme(
                backgroundColor: .foggyBackground,
                fontColor: .appDarkGray,
                pointColor1: .foggyPoint1,
                pointColor2: .foggyPoint2,
                animationName: "foggyAnimation"
            )
            
        case "stormy":
            return WeatherTheme(
                backgroundColor: .stormyBackground,
                fontColor: .white,
                pointColor1: .stormyPoint1,
                pointColor2: .stormyPoint2,
                animationName: "stormyAnimation"
            )
            
        default:
            return WeatherTheme(
                backgroundColor: .sunnyBackground,
                fontColor: .sunnyFont,
                pointColor1: .sunnyPoint1,
                pointColor2: .sunnyPoint2,
                animationName: "sunnyAnimation"
            )
        }
    }
    
}
