//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by 정유진 on 12/8/24.
//

import UIKit

extension UIView {
    // Adds multiple subviews to the view
    // 사용예시 : view.addSubviews(view1, view2, view3)
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

extension UIStackView {
    // Adds multiple arranged subviews to the stack view
    // 사용예시 : stackView.addArrangedSubviews(view1, view2, view3)
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
