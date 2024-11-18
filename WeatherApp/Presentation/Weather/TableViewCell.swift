//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by 정유진 on 10/4/24.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    private  let dtTxtLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }()
    
    private  let tempLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }()
    
    // TableView의 style, id 로 초기화를 할 때 사용하는 코드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .black
        [
            dtTxtLabel,
            tempLable
        ].forEach {
            contentView.addSubview($0)
        }
        
        dtTxtLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        tempLable.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    public func configureCell(forecastWeather: ForecastWeather) {
        dtTxtLabel.text = "\(forecastWeather.dtTxt)"
        tempLable.text = "\(forecastWeather.main.temp)°C"
    }
    
    // 인터페이스 빌더를 통해 셀을 초기화 할 때 사용하는 코드
    // 여기서는 fatalError 를 통해서 명시적으로 인터페이스 빌더로 초기화 하지 않음을 나타냄.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

