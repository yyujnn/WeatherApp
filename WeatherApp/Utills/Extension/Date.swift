//
//  Date.swift
//  WeatherApp
//
//  Created by 정유진 on 2/10/25.
//

import Foundation

extension Date {
    /// 현재 Date를 KST(Asia/Seoul) 시간으로 변환
    func toKST() -> Date {
        let kstTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let seconds = TimeInterval(kstTimeZone.secondsFromGMT(for: self))
        return self.addingTimeInterval(seconds)
    }
}
