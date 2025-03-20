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
    @Published var weatherCondition: WeatherCondition?
    @Published var hourlyWeather: [HourlyWeather] = []
    @Published var dailyWeather: [DailyWeather] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // 위치 정보 받아서 날씨 데이터 요청
    func fetchWeatherData(location: CLLocation) {
        let (lat, lon) = (location.coordinate.latitude, location.coordinate.longitude)
        fetchCurrentWeather(lat: lat, lon: lon)
        fetchForecastWeather(lat: lat, lon: lon)
    }
    
    private func fetchCurrentWeather(lat: Double, lon: Double) {
        WeatherAPIManager.shared.fetchCurrentWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main) // UI 업데이트를 위해 메인 스레드로 전환
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleError(error, message: "현재 날씨 불러오기 실패")
                }
            }, receiveValue: { [weak self] weatherData in
                guard let self = self else { return }
                self.currentWeather = weatherData
                print("현재 날씨: \(weatherData)")
                
                if let icon = weatherData.weather.first?.icon {
                    self.weatherCondition = self.mapWeatherCodeToCondition(icon)
                }
            })
            .store(in: &cancellables)
    }
    
    private func mapWeatherCodeToCondition(_ icon: String) -> WeatherCondition {
        switch icon {
        case "01d", "01n": return .sunny
        case "02d", "02n": return .cloudy
        case "09d", "09n", "10d", "10n": return .rainy
        case "13d", "13n": return .snowy
        case "50d", "50n": return .foggy
        case "11d", "11n": return .stormy
        default: return .sunny
        }
    }
    
    private func fetchForecastWeather(lat: Double, lon: Double) {
        WeatherAPIManager.shared.fetchForecastWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleError(error, message: "day 날씨 불러오기 실패")
                }
            }, receiveValue: { [weak self] forecastData in
                self?.updateHourlyWeather(forecastData)
                self?.updateDailyWeather(forecastData)
            })
            .store(in: &cancellables)
    }
   
    private func updateHourlyWeather(_ forecastData: ForecastWeatherResult) {
        guard let currentWeather = currentWeather else { return }
        
        let nowWeather = HourlyWeather(
            time: "Now",
            temp: Int(currentWeather.main.temp.rounded()),
            icon: currentWeather.weather.first?.icon ?? "01n"
        )
        
        let currentDate = Date().toKST()
        let futureDate = Calendar.current.date(byAdding: .hour, value: 27, to: currentDate)!
        
        // 27시간 이내 예보 필터링
        let filterForecast = forecastData.list.filter {
            guard let date = $0.kstDate else { return false }
            return date > currentDate && date <= futureDate
        }
        
        hourlyWeather = [nowWeather] + filterForecast.map { weather in
            return HourlyWeather(
                time: weather.kstTime ??  "--:--",
                temp: Int(weather.main.temp),
                icon: weather.weather.first?.icon ?? "01n"
            )
        }
    }
    
    private func updateDailyWeather(_ forecastData: ForecastWeatherResult) {
        
        // 날짜 기준 그룹화
        let groupedByDay = Dictionary(grouping: forecastData.list) { weather -> String? in
            return weather.dtDate?.basic
        }

        // 날짜 순 정렬
        let sortedByDate = groupedByDay.sorted { (lhs, rhs) in
            guard let leftDate = lhs.key?.toDate(),
                  let rightDate = rhs.key?.toDate() else { return false }
            return leftDate < rightDate
        }
   
        // DailyWeather로 변환
        let dailyWeatherList = sortedByDate.compactMap { (date, weathers) -> DailyWeather? in
            guard let date = date else { return nil }
            
            let minTemp = Int(weathers.map { $0.main.tempMin }.min()?.rounded() ?? 0.0)
            let maxTemp = Int(weathers.map { $0.main.tempMax }.max()?.rounded() ?? 0.0)

            
            let icon = mostFrequentIcon(weathers)
            
            return DailyWeather(day: date.toDayString() ?? "오류",
                                minTemp: minTemp,
                                maxTemp: maxTemp,
                                weatherIcon: icon)
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
    
    private func handleError(_ error: Error, message: String) {
        self.errorMessage = "\(message): \(error.localizedDescription)"
    }
}
