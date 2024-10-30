//
//  ViewController.swift
//  WeatherApp
//
//  Created by 정유진 on 9/9/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let tempLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "20도"
        label.font = .boldSystemFont(ofSize: 50)
        return label
    }()
    
    private let tempMinLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "20도"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let tempMaxLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "20도"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let tempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    private func configureUI() {
        view.backgroundColor = .black
        [
            titleLabel,
            tempLabel,
            tempStackView,
            imageView
        ].forEach{ view.addSubview($0) }
        
        [
            tempMinLabel,
            tempMaxLabel
        ].forEach{ tempStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        tempStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempLabel.snp.bottom).offset(10)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
            $0.top.equalTo(tempStackView.snp.bottom).offset(20)
        }
    }
}

