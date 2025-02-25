//
//  Date.swift
//  WeatherApp
//
//  Created by 정유진 on 2/10/25.
//

import Foundation

extension Date {
    // 현재 Date를 KST(Asia/Seoul) 시간으로 변환
    public func toKST() -> Date {
        let kstTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let seconds = TimeInterval(kstTimeZone.secondsFromGMT(for: self))
        return self.addingTimeInterval(seconds)
    }
    
    public var summary: String {
        return toString("yyyy-MM-dd HH:mm:ss")
      }
    
    public var basic: String {
        return toString("yyyy-MM-dd")
    }
    
    public var shortTime: String {
        return toString("HH:mm")
    }
    
    // MARK: - Date -> String
    public func toString(_ dateFormat: String) -> String {
        return DateFormatter
            .convertToKoKR(dateFormat: dateFormat)
            .string(from: self)
    }
}

extension DateFormatter {
    public static func convertToKoKR(dateFormat: String) -> DateFormatter {
        let dateFormatter = createKoKRFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
}

private func createKoKRFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    return dateFormatter
}
