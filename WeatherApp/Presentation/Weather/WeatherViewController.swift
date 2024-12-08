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
    
    private let titleLabel = UILabel().then {
        $0.text = "Seoul"
        $0.textColor = .appBlack
        $0.font = Gabarito.regular.of(size: 30)
    }
    
    private let tempLabel = UILabel().then {
        $0.textColor = .appBlack
        $0.text = "20"
        $0.font = Gabarito.medium.of(size: 100)
    }
    
    private let degreeLabel = UILabel().then {
        $0.textColor = .appBlack
        $0.text = "°"
        $0.font = Gabarito.medium.of(size: 100)
    }
    
    private let stateLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.text = "Sunny"
        $0.font = Gabarito.regular.of(size: 26)
    }
    
    private let tempMinLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.text = "L: 20°"
        $0.font = Gabarito.semibold.of(size: 20)
    }
    
    private let tempMaxLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.text = "H: 20°"
        $0.font = Gabarito.semibold.of(size: 20)
    }
    
    private let tempStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    
    private let leftAnimationView = LottieAnimationView(name: "sunnyAnimation")
    private let rightAnimationView = LottieAnimationView(name: "sunnyAnimation")
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.delegate = self
        $0.dataSource = self
        $0.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        setupLottieAnimations()
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
    
    private func configureUI() {
        view.backgroundColor = .sunnyBackground
        [
            titleLabel,
            tempLabel,
            degreeLabel,
            stateLabel,
            tempStackView,
            leftAnimationView,
            rightAnimationView,
            tableView
        ].forEach{ view.addSubview($0) }
        
        [
            tempMaxLabel,
            tempMinLabel
        ].forEach{ tempStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(rightAnimationView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(100)
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else { return UITableViewCell() }
        cell.configureCell(forecastWeather: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
}
//#Preview{
//    WeatherViewController()
//}
