//
//  SearchResultCell.swift
//  WeatherApp
//
//  Created by 정유진 on 3/14/25.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    static let identifier = "SearchResultCell"

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "--"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with city: String) {
        cityLabel.text = city
    }
}
