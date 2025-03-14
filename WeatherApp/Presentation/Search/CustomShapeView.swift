//
//  CustomShapeView.swift
//  WeatherApp
//
//  Created by 정유진 on 3/13/25.
//

import UIKit

class CustomShapeView: UIView {

    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyMask()
        gradientLayer.frame = bounds
    }
    
    // MARK: - 배경 그라데이션
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.sunnyFont.withAlphaComponent(0.2).cgColor,
            UIColor.sunnyPoint2.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - 비대칭 레이아웃
    private func applyMask() {
        let width = bounds.width
        let height = bounds.height
        let path = UIBezierPath()
        let cornerRadius: CGFloat = 22
        let topLeftSlantWidth: CGFloat = 30

        // 우측 기울기 조정
        let slantStopY: CGFloat = height * 0.4
        
        // 왼쪽 상단 둥근 모서리
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: topLeftSlantWidth, y: 0), controlPoint: CGPoint.zero)
        
        // 기울어진 우측 상단
        path.addLine(to: CGPoint(x: width - cornerRadius, y: slantStopY))
        path.addQuadCurve(to: CGPoint(x: width, y: slantStopY + cornerRadius), controlPoint: CGPoint(x: width, y: slantStopY))
        
        // 우측 세로선
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        path.addQuadCurve(to: CGPoint(x: width - cornerRadius, y: height), controlPoint: CGPoint(x: width, y: height))
        
        // 하단 직선
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - cornerRadius), controlPoint: CGPoint(x: 0, y: height))
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        // mask 적용
        layer.mask = shapeLayer
    }
}
#Preview {
    SearchViewController()
}
