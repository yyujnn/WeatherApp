//
//  String.swift
//  WeatherApp
//
//  Created by 정유진 on 2/25/25.
//

import Foundation

extension String {
    // "yyyy-MM-dd" 형태의 문자열을 요일로 변환
    func toDayString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        guard let date = formatter.date(from: self) else { return nil }
        
        // 오늘: "Today" 반환
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        
        // 요일 변환
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US") // 영어 요일로 표시
        
        return formatter.string(from: date)
    }
    
    // "yyyy-MM-dd" 형태의 문자열을 Date로 변환
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter.date(from: self)
    }
}
