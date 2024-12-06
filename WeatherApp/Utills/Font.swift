//
//  Font.swift
//  WeatherApp
//
//  Created by 정유진 on 11/18/24.
//

import UIKit

/// 폰트를 사용할 때는 아래와 같이 사용
/// let font = Gabarito.bold.of(size: 16)
enum Gabarito: String {
    case bold = "Gabarito-Bold"
    case semibold = "Gabarito-SemiBold"
    case medium = "Gabarito-Medium"
    case regular = "Gabarito-Regular"

    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            fatalError("Failed to load font: \(self.rawValue)")
        }
        return font
    }
}

