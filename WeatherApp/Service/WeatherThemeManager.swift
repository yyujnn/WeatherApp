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
    
    func applyTheme(_ condition: WeatherCondition) -> WeatherTheme {
        switch condition {
        case .sunny:
            return WeatherTheme(
                backgroundColor: .sunnyBackground,
                fontColor: .sunnyFont,
                pointColor1: .sunnyPoint1,
                pointColor2: .sunnyPoint2,
                animationName: "sunnyAnimation"
            )
            
        case .cloudy:
            return WeatherTheme(
                backgroundColor: .cloudyBackground,
                fontColor: .appDarkGray,
                pointColor1: .cloudyPoint1,
                pointColor2: .cloudyPoint2,
                animationName: "cloudyAnimation"
            )
            
        case .rainy:
            return WeatherTheme(
                backgroundColor: .rainyBackground,
                fontColor: .appDarkGray,
                pointColor1: .rainyPoint1,
                pointColor2: .rainyPoint2,
                animationName: "rainyAnimation"
            )
            
        case .snowy:
            return WeatherTheme(
                backgroundColor: .snowyBackground,
                fontColor: .snowyFont,
                pointColor1: .snowyPoint1,
                pointColor2: .snowyPoint2,
                animationName: "snowyAnimation"
            )
            
        case .foggy:
            return WeatherTheme(
                backgroundColor: .foggyBackground,
                fontColor: .appDarkGray,
                pointColor1: .foggyPoint1,
                pointColor2: .foggyPoint2,
                animationName: "foggyAnimation"
            )
            
        case .stormy:
            return WeatherTheme(
                backgroundColor: .stormyBackground,
                fontColor: .white,
                pointColor1: .stormyPoint1,
                pointColor2: .stormyPoint2,
                animationName: "stormyAnimation"
            )
        }
    }
}

enum WeatherCondition {
    case sunny, cloudy, rainy, snowy, foggy, stormy
}

struct WeatherIconManager {
    
    enum IconType {
        case hourly  // 시간별 (d/n 구분 유지)
        case daily   // 하루 (대표 아이콘만 표시)
    }
    
    static func getSystemIconName(_ iconCode: String, type: IconType) -> String {
        
        // iconCode에 따른 낮/밤 아이콘 매칭
        let iconMap: [String: (day: String, night: String)] = [
            "01": ("sun.max.fill", "moon.stars.fill"), // 맑음 (clear sky)
            "02": ("cloud.sun.fill", "cloud.moon.fill"), // 약간 흐림 (few clouds)
            "03": ("cloud.fill", "cloud.fill"), // 흐림 (scattered clouds)
            "04": ("smoke.fill", "smoke.fill"), // 구름 많음 (broken clouds)
            "09": ("cloud.drizzle.fill", "cloud.drizzle.fill"), // 소나기 (shower rain)
            "10": ("cloud.rain.fill", "cloud.rain.fill"), // 비 (rain)
            "11": ("cloud.bolt.fill", "cloud.bolt.fill"), // 천둥번개 (thunderstorm)
            "13": ("snow", "snow"), // 눈 (snow)
            "50": ("cloud.fog.fill", "cloud.fog.fill") // 안개 (mist)
        ]
        
        let codePrefix = String(iconCode.prefix(2)) // "01d" -> "01"
        let isNight = iconCode.hasSuffix("n")
        
        guard let icons = iconMap[codePrefix] else {
            return "cloud" // 기본 아이콘
        }
        
        switch type {
        case .hourly:
            return isNight ? icons.night : icons.day
        case .daily:
            return icons.day // 항상 낮 아이콘 사용
        }
    }
}
