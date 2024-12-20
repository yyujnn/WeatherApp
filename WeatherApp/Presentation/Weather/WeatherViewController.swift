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
    
    // URL 쿼리 아이템들.
    // 서울역 위경도.
    private let urlQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "lat", value: "37.5"),
        URLQueryItem(name: "lon", value: "126.9"),
        URLQueryItem(name: "appid", value: "58507548be95806c09ad4d26225b141b"),
        URLQueryItem(name: "units", value: "metric")
    ]
    
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
        
        setupLottieAnimations()
        
        updateThme(for: "sunny")
//        fetchCurrentWeatherData()
//        fetchForecastData()
    }
    
    private func setupLottieAnimations() {
        leftAnimationView.contentMode = .scaleAspectFit
        leftAnimationView.loopMode = .loop
        leftAnimationView.animationSpeed = 0.5
        
        rightAnimationView.contentMode = .scaleAspectFit
        rightAnimationView.loopMode = .loop
        rightAnimationView.animationSpeed = 0.5
        
        leftAnimationView.play()
        rightAnimationView.play()
    }
    
    // 서버 데이터 불러오는 메서드
    /// 제네릭: T에는 Decodable을 준수하는 어떤 타입이든 들어올 수 있다.
    /// @escaping: 메서드가 끝이 나더라도 탈출하여 언제든지 실행되는 클로저
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)){data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            // http status code 성공범위는 200번대.
            let successRange = 200..<399
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodeData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
    // 서버에서 현재 날씨 데이터를 불러오는 메서드.
    private func fetchCurrentWeatherData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        urlComponents?.queryItems = self.urlQueryItems
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        fetchData(url: url) { [weak self] (result: CurrentWeatherResult?) in
            guard let self, let result else { return }
            // UI 작업은 메인 쓰레드에서 작업
            DispatchQueue.main.async {
                self.tempLabel.text = "\(Int(result.main.temp))"
                self.tempMinLabel.text = "L: \(Int(result.main.tempMin))°"
                self.tempMaxLabel.text = "H: \(Int(result.main.tempMax))°"
            }
        }
    }
    
    // 서버에서 5일 간 날씨 예보 데이터를 불러오는 메서드
    private func fetchForecastData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")
        urlComponents?.queryItems = self.urlQueryItems
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        fetchData(url: url) { [weak self] (result: ForecastWeatherResult?) in
            guard let self, let result else { return }
            
            // result 콘솔에 찍어보기
            for forecastWeather in result.list {
                print("\(forecastWeather.main)\n\(forecastWeather.dtTxt)\n\n")
            }
            
            DispatchQueue.main.async {
                self.dataSource = result.list
                self.tableView.reloadData()
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.identifier, for: indexPath) as? HourlyForecastCell else { return UICollectionViewCell() }
        
        cell.configure(time: "15:00", temperature: "\(indexPath.item)", iconName: "sun.max.fill")
        
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
#Preview{
    WeatherViewController()
}
