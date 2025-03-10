//
//  SearchCell.swift
//  WeatherApp
//
//  Created by 정유진 on 3/1/25.
//

import UIKit
import SnapKit
import Then

class SavedLocationCell: UICollectionViewCell {
    
    static let identifier = "SavedLocationCell"
    
    private let temperatureLabel = UILabel().then {
        $0.font = Gabarito.semibold.of(size: 48)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    private let locationLabel = UILabel().then {
        $0.font =  Gabarito.regular.of(size: 16)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    private let timeLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 14)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let weatherIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let conditionLabel = UILabel()
    private let tempStackView = UIStackView()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGradient()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    // MARK: - 비대칭 카드 레이아웃
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 그라디언트 크기 조정
        gradientLayer.frame = bounds
        
        let width = bounds.width
        let height = bounds.height
        
        // 커스텀 모양 적용
        let path = UIBezierPath()
        let cornerRadius: CGFloat = 22
        let slantHeight: CGFloat = 30

        let slantStopY: CGFloat = height * 0.4  // 우측 기울기 조정
        
        // 왼쪽 상단 둥근 모서리
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: slantHeight, y: 0), controlPoint: CGPoint.zero)
        
        // 기울어진 우측 상단
        path.addLine(to: CGPoint(x: width - cornerRadius, y: slantStopY))
        path.addQuadCurve(to: CGPoint(x: width, y: slantStopY + cornerRadius), controlPoint: CGPoint(x: width, y: slantStopY))  // 둥글게 변환
        
        // 우측 세로선
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        path.addQuadCurve(to: CGPoint(x: width - cornerRadius, y: height), controlPoint: CGPoint(x: width, y: height))
        
        // 하단 직선
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - cornerRadius), controlPoint: CGPoint(x: 0, y: height))
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }

    // MARK: - Cell UI
    private func setupUI() {
        contentView.addSubviews(temperatureLabel, timeLabel, weatherIcon, locationLabel)
    }
    
    private func setupConstraints() {
        temperatureLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        locationLabel.snp.makeConstraints {
            $0.bottom.equalTo(timeLabel.snp.top)
            $0.leading.equalToSuperview().inset(16)
        }
        
        weatherIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(location: String) {
        temperatureLabel.text = "13°"
        locationLabel.text = location
        timeLabel.text = "time or My Location"
        weatherIcon.image = UIImage(systemName: "sun.max.fill")
        
    }
}
