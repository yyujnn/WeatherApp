//
//  WeatherThemeManager.swift
//  WeatherApp
//
//  Created by 정유진 on 12/10/24.
//

import UIKit

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

struct WeatherIconManager {
    
    static func getSystemIconName(_ iconCode: String) -> String {
        switch iconCode {
        case "01d": return "sun.max.fill"     // 맑은 낮
        case "01n": return "moon.stars.fill"  // 맑은 밤
        case "02d", "02n": return "cloud.sun.fill" // 약간 흐림
        case "03d", "03n": return "cloud.fill" // 흐림
        case "09d", "09n": return "cloud.drizzle.fill" // 이슬비
        case "10d", "10n": return "cloud.rain.fill"  // 비
        case "11d", "11n": return "cloud.bolt.fill"  // 천둥번개
        case "13d", "13n": return "snow"      // 눈
        case "50d", "50n": return "cloud.fog.fill"  // 안개
        default: return "cloud"              // 기본값
        }
    }
}
