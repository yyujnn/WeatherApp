//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 정유진 on 2/10/25.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel {

    @Published var currentWeather: CurrentWeatherResult?
    @Published var hourlyWeather: HourlyWeatherResult?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // 위치 정보 받아서 날씨 데이터 요청
    func fetchWeatherData(location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        print("location: (\(lat), \(lon))")
        
        // 현재 날씨 데이터 가져오기
        WeatherAPIManager.shared.fetchCurrentWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main) // UI 업데이트를 위해 메인 스레드로 전환
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "현재 날씨 불러오기 실패: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] weatherData in
                self?.currentWeather = weatherData
            })
            .store(in: &cancellables)
        
        // 시간별 날씨 데이터 가져오기
        WeatherAPIManager.shared.fetchHourlyWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "시간별 날씨 불러오기 실패: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] hourlyData in
                self?.hourlyWeather = hourlyData
            })
            .store(in: &cancellables)
    }
}
