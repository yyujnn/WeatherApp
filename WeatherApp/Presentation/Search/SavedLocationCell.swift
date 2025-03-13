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
    
    private let customView = CustomShapeView()
    
    private let temperatureLabel = UILabel().then {
        $0.font = Gabarito.semibold.of(size: 48)
        $0.textColor = .white
        $0.text = "°"
        $0.textAlignment = .left
    }
    
    private let tempMinLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "L: --°"
        $0.font = Gabarito.regular.of(size: 14)
    }
    
    private let tempMaxLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "H: --°"
        $0.font = Gabarito.regular.of(size: 14)
    }
    
    private let tempStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
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
        $0.clipsToBounds = false
    }
    
    private let conditionLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 14)
        $0.text = "--"
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cell UI
    private func setupUI() {
        contentView.addSubviews(customView, weatherIcon)
        customView.addSubviews(temperatureLabel, tempStackView, locationLabel, timeLabel, conditionLabel)
        
        tempStackView.addArrangedSubviews(tempMaxLabel, tempMinLabel)
    }
    
    private func setupConstraints() {
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.width.equalTo(80)
        }
        
        tempStackView.snp.makeConstraints {
            $0.leading.equalTo(temperatureLabel.snp.trailing)
            $0.lastBaseline.equalTo(temperatureLabel.snp.lastBaseline)
        }
        
        locationLabel.snp.makeConstraints {
            $0.bottom.equalTo(timeLabel.snp.top)
            $0.leading.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.bottom.equalTo(timeLabel)
             $0.leading.centerX.equalTo(weatherIcon)
        }
        
        weatherIcon.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(CGSize(width: 80, height: 80))
        }
    }
    
    // MARK: - Configure
    func configure(location: String) {
        temperatureLabel.text = "13°"
        locationLabel.text = location
        timeLabel.text = "time or My Location"
        weatherIcon.image = UIImage(systemName: "sun.max.fill")
        conditionLabel.text = "sunny"
    }
}
