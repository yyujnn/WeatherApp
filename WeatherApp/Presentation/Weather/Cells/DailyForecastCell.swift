//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by 정유진 on 10/4/24.
//

import UIKit
import SnapKit

final class DailyForecastCell: UITableViewCell {
    
    static let identifier = "DailyForecastCell"
    
    private let dayLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 16)
        $0.textColor = .white
    }
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "sun.max.fill")
        $0.tintColor = .white
    }
    
    private let minImageView = UIImageView().then {
        $0.image = .down
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .blue
    }
    
    private let tempMinLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 16)
        $0.textColor = .white
    }
    
    private let maxImageView = UIImageView().then {
        $0.image = .up
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .red
    }
    
    private let tempMaxLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 16)
        $0.textColor = .white
    }
    
    private let minTempStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    private let maxTempStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        [
            dayLabel,
            iconImageView,
            minTempStack,
            maxTempStack
        ].forEach {
            contentView.addSubview($0)
        }
        
        minTempStack.addArrangedSubviews(minImageView, tempMinLabel)
        
        maxTempStack.addArrangedSubviews(maxImageView, tempMaxLabel)
    }
    
    private func setupConstraints() {
        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-32)
            $0.width.height.equalTo(24)
        }
        
        minTempStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.centerX.equalToSuperview().offset(60)
        }
        
        maxTempStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(minTempStack.snp.trailing).offset(16)
        }
        
        minImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
        }
        
        tempMinLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        maxImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
        }
        
        tempMaxLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
    
    public func configureCell(weather: DailyWeather) {
        dayLabel.text = weather.day
        tempMaxLabel.text = "\(String(weather.maxTemp))°"
        tempMinLabel.text = "\(String(weather.minTemp))°"
        
        let iconName = WeatherIconManager.getSystemIconName(weather.weatherIcon, type: .daily)
        iconImageView.image = UIImage(systemName: iconName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
