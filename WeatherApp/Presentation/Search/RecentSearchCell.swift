//
//  RecentSearchCell.swift
//  WeatherApp
//
//  Created by 정유진 on 3/19/25.
//

import UIKit

class RecentSearchCell: UITableViewCell {
    // 최근 검색어 cell
    static let identifier = "RecentSearchCell"
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "clock")
        $0.tintColor = .gray
        $0.contentMode = .scaleAspectFit
    }
    
    private let locationLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .foggyPoint1
    }

    var deleteAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubviews(iconImageView, locationLabel, deleteButton)
        
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }

        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with location: String) {
        locationLabel.text = location
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
}
