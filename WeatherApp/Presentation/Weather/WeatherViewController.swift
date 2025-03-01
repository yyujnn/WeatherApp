//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by 정유진 on 9/9/24.
//

import UIKit
import Combine
import Lottie
import SnapKit
import Then

class WeatherViewController: UIViewController {

    private var viewModel = WeatherViewModel()
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var hourlyData: [HourlyWeather] = []
    private var dailyData: [DailyWeather] = []
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let leftAnimationView = LottieAnimationView()
    private let rightAnimationView = LottieAnimationView()
    
    private let cityLabel = UILabel().then {
        $0.text = "Loading..."
        $0.textColor = .sunnyFont
        $0.font = Gabarito.regular.of(size: 30)
    }
    
    private let tempLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "--"
        $0.font = Gabarito.medium.of(size: 100)
    }
    
    private let degreeLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "°"
        $0.font = Gabarito.medium.of(size: 100)
    }
    
    private let conditionLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "--"
        $0.font = Gabarito.regular.of(size: 26)
    }
    
    private let tempMinLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "L: --°"
        $0.font = Gabarito.semibold.of(size: 20)
    }
    
    private let tempMaxLabel = UILabel().then {
        $0.textColor = .sunnyFont
        $0.text = "H: --°"
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
    
    private let hourlyLabel = UILabel().then {
        $0.text = "Hourly Forecast"
        $0.font = Gabarito.regular.of(size: 14)
        $0.textColor = .sunnyFont
    }
    
    private let separatorLine = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let dailyForecastView = UIView().then {
        $0.backgroundColor = .sunnyPoint2
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let calendarImageView = UIImageView().then {
        $0.image = UIImage(systemName: "calendar")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .sunnyFont
    }
    
    private let dailyLabel = UILabel().then {
        $0.text = "Daily Forecast"
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
        $0.allowsSelection = false
        $0.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindLocationUpdates()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leftAnimationView.stop()
        rightAnimationView.stop()
        leftAnimationView.removeFromSuperview()
        rightAnimationView.removeFromSuperview()
    }
    
    // 위치 업데이트 바인딩
    private func bindLocationUpdates() {
        locationManager.$currentLocation
            .compactMap { $0 }  // nil 값 필터링
            .sink { [weak self] location in
                self?.viewModel.fetchWeatherData(location: location)  // 위치 정보로 날씨 요청
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        // 현재 날씨 데이터 바인딩
        viewModel.$currentWeather
            .compactMap { $0 } // nil 값 필터링
            .sink { [weak self] currentData in
                self?.updateCurrentWeatherUI(data: currentData)
            }
            .store(in: &cancellables)
        
        viewModel.$weatherCondition
            .compactMap { $0 } // nil 제거
            .sink { [weak self] condition in
                self?.applyTheme(for: condition)
                self?.setupLottieAnimations()
            }
            .store(in: &cancellables)
        
        // 시간별 날씨 데이터 바인딩
        viewModel.$hourlyWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hourlyData in
                self?.hourlyData = hourlyData
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // 날짜별 날씨 데이터 바인딩
        viewModel.$dailyWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dailyData in
                self?.dailyData = dailyData
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // 에러 메시지 바인딩
        viewModel.$errorMessage
            .compactMap { $0 } // nil 값은 무시
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func applyTheme(for condition: WeatherCondition) {
        let theme = WeatherThemeManager.shared.applyTheme( condition)
        conditionLabel.text = "\(condition)"
        view.backgroundColor = theme.backgroundColor
        cityLabel.textColor = theme.fontColor
        tempLabel.textColor = theme.fontColor
        degreeLabel.textColor = theme.fontColor
        conditionLabel.textColor = theme.fontColor
        tempMaxLabel.textColor = theme.fontColor
        tempMinLabel.textColor = theme.fontColor
        hourlyForecastView.backgroundColor = theme.pointColor1
        clockImageView.tintColor = theme.fontColor
        hourlyLabel.textColor = theme.fontColor
        calendarImageView.tintColor = theme.fontColor
        dailyLabel.textColor = theme.fontColor
        dailyForecastView.backgroundColor = theme.pointColor2
        
        leftAnimationView.animation = LottieAnimation.named(theme.animationName)
        rightAnimationView.animation = LottieAnimation.named(theme.animationName)
    }
    
    private func updateCurrentWeatherUI(data: CurrentWeatherResult) {
        tempLabel.text = "\(Int(data.main.temp.rounded()))"
        cityLabel.text = data.name
        tempMinLabel.text = "L: \(Int(data.main.tempMin.rounded()))°"
        tempMaxLabel.text = "H: \(Int(data.main.tempMax.rounded()))°"
    }

    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    
    private func setupLottieAnimations() {
        configureLottieView(leftAnimationView)
        configureLottieView(rightAnimationView)
    }
    
    private func configureLottieView(_ animationView: LottieAnimationView) {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.play()
    }
    
    private func setupViews() {
        view.backgroundColor = .sunnyBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(cityLabel,
                         tempLabel,
                         degreeLabel,
                         conditionLabel,
                         tempStackView,
                         leftAnimationView,
                         rightAnimationView,
                         hourlyForecastView,
                         dailyForecastView
        )

        tempStackView.addArrangedSubviews(tempMaxLabel, tempMinLabel)
        
        hourlyForecastView.addSubviews(clockImageView, hourlyLabel, separatorLine, collectionView)
        
        dailyForecastView.addSubviews(calendarImageView, dailyLabel, separatorLine2, tableView)
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(dailyForecastView.snp.bottom).offset(16)
        }
        
        cityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cityLabel.snp.bottom).offset(14)
        }
        
        degreeLabel.snp.makeConstraints {
            $0.centerY.equalTo(tempLabel.snp.centerY)
            $0.left.equalTo(tempLabel.snp.right).offset(4)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tempLabel.snp.bottom).offset(10)
        }
        
        tempStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(conditionLabel.snp.bottom).offset(12)
        }
        
        leftAnimationView.snp.makeConstraints {
            $0.top.equalTo(cityLabel)
            $0.leading.equalToSuperview().offset(-20)
            $0.width.height.equalTo(120)
        }
        
        rightAnimationView.snp.makeConstraints {
            $0.top.equalTo(conditionLabel)
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
        
        hourlyLabel.snp.makeConstraints {
            $0.centerY.equalTo(clockImageView)
            $0.leading.equalTo(clockImageView.snp.trailing).offset(4)
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(clockImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(0.5)
        }
        
        dailyForecastView.snp.makeConstraints {
            $0.top.equalTo(hourlyForecastView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(20)
        }
        
        dailyLabel.snp.makeConstraints {
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
}
extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.identifier, for: indexPath) as? HourlyForecastCell else { return UICollectionViewCell() }
        
        let weather = hourlyData[indexPath.item]
        cell.configureCell(weather: weather)
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier) as? DailyForecastCell else { return UITableViewCell() }
        cell.configureCell(weather: dailyData[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyData.count
    }
}
