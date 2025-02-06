//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by 정유진 on 9/9/24.
//

import UIKit
import Lottie
import SnapKit
import Then

class WeatherViewController: UIViewController {

    private var dataSource = [ForecastWeather]()
    private var houlyData = [HourlyWeather]()
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let leftAnimationView = LottieAnimationView()
    private let rightAnimationView = LottieAnimationView()
    
    private let titleLabel = UILabel().then {
        $0.text = "Seoul"
        $0.textColor = .sunnyFont
        $0.font = Gabarito.regular.of(size: 30)
    }
    
    private let tempLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "20"
        $0.font = Gabarito.medium.of(size: 100)
    }
    
    private let degreeLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "°"
        $0.font = Gabarito.medium.of(size: 100)
    }
    
    private let stateLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "Sunny"
        $0.font = Gabarito.regular.of(size: 26)
    }
    
    private let tempMinLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "L: 20°"
        $0.font = Gabarito.semibold.of(size: 20)
    }
    
    private let tempMaxLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "H: 20°"
        $0.font = Gabarito.semibold.of(size: 20)
    }
    
    private let tempStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    
    private let hourlyForecastView = UIView().then {
        $0.backgroundColor = .sunnyPoint1
        $0.layer.cornerRadius = 26
        $0.clipsToBounds = true
    }
    
    private let clockImageView = UIImageView().then {
        $0.image = UIImage(systemName: "clock")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .sunnyFont
    }
    
    private let hourLable = UILabel().then {
        $0.text = "Hourly Forecast"
        $0.font = Gabarito.regular.of(size: 14)
        $0.textColor = .sunnyFont
    }
    
    private let separatorLine = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let weeklyForecastView = UIView().then {
        $0.backgroundColor = .sunnyPoint2
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let calendarImageView = UIImageView().then {
        $0.image = UIImage(systemName: "calendar")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .sunnyFont
    }
    
    private let weekLable = UILabel().then {
        $0.text = "Weekly Forecast"
        $0.font = Gabarito.regular.of(size: 14)
        $0.textColor = .sunnyFont
    }
    
    private let separatorLine2 = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false // 스크롤바 숨김
        $0.delegate = self
        $0.dataSource = self
        $0.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.identifier)
    }
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal // 가로 스크롤
        $0.minimumLineSpacing = 10 // 셀 간 간격
        $0.itemSize = CGSize(width: 60, height: 80)
    }
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.register(WeeklyForecastCell.self, forCellReuseIdentifier: WeeklyForecastCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        updateThme(for: "sunny")
        setupLottieAnimations()
        fetchCurrentWeather()
        fetchHourlyForecast()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leftAnimationView.stop()
        rightAnimationView.stop()
    }
    
    private func setupLottieAnimations() {
        configureLottieView(leftAnimationView)
        configureLottieView(rightAnimationView)
    }
    
    private func configureLottieView(_ animationView: LottieAnimationView) {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
    }
    
    private func fetchCurrentWeather() {
        WeatherAPIManager.shared.fetchCurrentWeather(lat: 37.5, lon: 126.9) { result in
            switch result {
            case .success(let data):
                print("weather: \(data.weather.first?.main ?? "Unknown")")
                print("city: \(data.name)")
                print("Temperature: \(data.main.temp)°C")
                DispatchQueue.main.async {
                    self.titleLabel.text = data.name
                    self.tempLabel.text = "\(Int(data.main.temp))"
                    self.tempMinLabel.text = "L: \(Int(data.main.tempMin))°"
                    self.tempMaxLabel.text = "H: \(Int(data.main.tempMax))°"
                }
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchHourlyForecast() {
        WeatherAPIManager.shared.fetchHourlyWeather(lat: 37.5, lon: 126.9) { result in
            switch result {
            case .success(let data):
                print("Hourly: \(data)")
                self.houlyData = data.list
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .sunnyBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(titleLabel,
                         tempLabel,
                         degreeLabel,
                         stateLabel,
                         tempStackView,
                         leftAnimationView,
                         rightAnimationView,
                         hourlyForecastView,
                         weeklyForecastView
        )

        tempStackView.addArrangedSubviews(tempMaxLabel, tempMinLabel)
        
        hourlyForecastView.addSubviews(clockImageView, hourLable, separatorLine, collectionView)
        
        weeklyForecastView.addSubviews(calendarImageView, weekLable, separatorLine2, tableView)
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(weeklyForecastView.snp.bottom).offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
        }
        
        degreeLabel.snp.makeConstraints {
            $0.centerY.equalTo(tempLabel.snp.centerY)
            $0.left.equalTo(tempLabel.snp.right).offset(4)
        }
        
        stateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempLabel.snp.bottom).offset(10)
        }
        
        tempStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stateLabel.snp.bottom).offset(12)
        }
        
        leftAnimationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.leading.equalToSuperview().offset(-20)
            $0.width.height.equalTo(120)
        }
        
        rightAnimationView.snp.makeConstraints {
            $0.top.equalTo(stateLabel)
            $0.trailing.equalToSuperview().offset(20)
            $0.width.height.equalTo(120)
        }
        
        hourlyForecastView.snp.makeConstraints {
            $0.top.equalTo(tempStackView.snp.bottom).offset(64)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(140)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        clockImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        
        hourLable.snp.makeConstraints {
            $0.centerY.equalTo(clockImageView)
            $0.leading.equalTo(clockImageView.snp.trailing).offset(4)
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(clockImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(0.5)
        }
        
        weeklyForecastView.snp.makeConstraints {
            $0.top.equalTo(hourlyForecastView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(340)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        
        weekLable.snp.makeConstraints {
            $0.centerY.equalTo(calendarImageView)
            $0.leading.equalTo(calendarImageView.snp.trailing).offset(4)
        }
        
        separatorLine2.snp.makeConstraints {
            $0.top.equalTo(calendarImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(0.5)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorLine2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    // 테마 업데이트 메서드
    private func updateThme(for weather: String) {
        let theme = WeatherThemeManager.shared.updateTheme(for: weather)
        
        view.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.fontColor
        tempLabel.textColor = theme.fontColor
        degreeLabel.textColor = theme.fontColor
        stateLabel.textColor = theme.fontColor
        tempMaxLabel.textColor = theme.fontColor
        tempMinLabel.textColor = theme.fontColor
        hourlyForecastView.backgroundColor = theme.pointColor1
        clockImageView.tintColor = theme.fontColor
        hourLable.textColor = theme.fontColor
        calendarImageView.tintColor = theme.fontColor
        weekLable.textColor = theme.fontColor
        weeklyForecastView.backgroundColor = theme.pointColor2
        
        leftAnimationView.animation = LottieAnimation.named(theme.animationName)
        rightAnimationView.animation = LottieAnimation.named(theme.animationName)
    }
}
extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.identifier, for: indexPath) as? HourlyForecastCell else { return UICollectionViewCell() }
        
        let weather = houlyData[indexPath.item]
        cell.configure(weather: weather)
        
        return cell
    }
}
                                    
extension WeatherViewController: UITableViewDelegate {
    // 테이블 뷰 셀 높이 크기 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension WeatherViewController: UITableViewDataSource {
    // 테이블 뷰의 indexPath마다 테이블 뷰 셀을 지정.
    // indexPath: 테이블 뷰의 셀과 섹션을 의미
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeeklyForecastCell.identifier) as? WeeklyForecastCell else { return UITableViewCell() }
        cell.configureCell()
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}
//#Preview{
//    WeatherViewController()
//}
