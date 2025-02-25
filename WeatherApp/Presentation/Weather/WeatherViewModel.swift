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
    @Published var hourlyWeather: [ForecastWeather] = []
    @Published var dailyWeather: [DailyWeather] = [] // 가공된 데이터 저장
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
        
        // 5day 날씨 데이터 가져오기
        WeatherAPIManager.shared.fetchForecastWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "day 날씨 불러오기 실패: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] forecastData in
                self?.updateHourlyWeather(forecastData)
                self?.updateDailyWeather(forecastData)
            })
            .store(in: &cancellables)
    }
    
    private func updateHourlyWeather(_ forecastData: ForecastWeatherResult) {
        let currentDate = Date().toKST() // 현재 서울 시간
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .hour, value: 27, to: currentDate)!

        // 데이터 가공
        hourlyWeather = forecastData.list.filter { weather in
            if let date = weather.kstDate {
                return date > currentDate && date <= futureDate
            }
            return false
        }
    }
    
    private func updateDailyWeather(_ forecastData: ForecastWeatherResult) {
        
        // 1. 날짜 기준으로 그룹화: yyyy-MM-dd
        let groupedByDay = Dictionary(grouping: forecastData.list) { weather -> String? in
            return weather.dtDate?.basic
        }

        // 2. 날짜 순으로 정렬
        let sortedByDate = groupedByDay.sorted { (lhs, rhs) in
            guard let leftDate = lhs.key?.toDate(),
                  let rightDate = rhs.key?.toDate() else { return false }
            return leftDate < rightDate
        }
   
        // 3. 정렬된 데이터를 DailyWeather로 변환
        let dailyWeatherList = sortedByDate.compactMap { (date, weathers) -> DailyWeather? in
            guard let date = date else { return nil }
            
            let minTemp = Int(weathers.map { $0.main.tempMin }.min()?.rounded() ?? 0.0)
            let maxTemp = Int(weathers.map { $0.main.tempMax }.max()?.rounded() ?? 0.0)

            
            // 가장 자주 등장하는 날씨 아이콘
            let icon = mostFrequentIcon(weathers)
            
            return DailyWeather(day: date.toDayString() ?? "오류", minTemp: minTemp, maxTemp: maxTemp, weatherIcon: icon)
        }
        
        self.dailyWeather = dailyWeatherList
    }
    
    // 가장 자주 등장하는 아이콘을 반환
    private func mostFrequentIcon(_ weathers: [ForecastWeather]) -> String {
        let iconFrequency = weathers.reduce(into: [String: Int]()) { counts, weather in
            let icon = weather.weather.first?.icon ?? ""
            counts[icon] = (counts[icon] ?? 0) + 1
        }
        return iconFrequency.max { $0.value < $1.value }?.key ?? "01d"
    }
}
