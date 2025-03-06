//
//  SearchCell.swift
//  WeatherApp
//
//  Created by 정유진 on 3/1/25.
//

import UIKit
import SnapKit

class SearchCell: UITableViewCell {
    
    static let identifier = "SearchCell"

    let cityLabel = UILabel().then {
        $0.font = Gabarito.regular.of(size: 16)
        $0.textColor = .appBlack
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        cityLabel.text = text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
