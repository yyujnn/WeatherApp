//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by 정유진 on 12/6/24.
//

import UIKit
import Then

class HourlyForecastCell: UICollectionViewCell {
    
    static let identifier = "HourlyForecastCell"
    
   private let timeLabel = UILabel().then {
       $0.font = Gabarito.regular.of(size: 16)
       $0.textColor = .white
       $0.textAlignment = .center
    } 
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let temperatureLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 18)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubviews(timeLabel, iconImageView, temperatureLabel)
    }
    
    private func setupConstraints() {
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(26)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(weather: HourlyWeather) {
        timeLabel.text = weather.time
        temperatureLabel.text = "\(weather.temp)°"
        
        let iconName = WeatherIconManager.getSystemIconName(weather.icon, type: .hourly)
        iconImageView.image = UIImage(systemName: iconName)
    }
}
