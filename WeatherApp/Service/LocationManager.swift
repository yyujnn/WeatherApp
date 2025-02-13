//
//  LocationManager.swift
//  WeatherApp
//
//  Created by 정유진 on 2/12/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()  // 앱 사용 중 위치 권한 요청
        locationManager.startUpdatingLocation()  // 위치 업데이트 시작
    }
}
extension LocationManager: CLLocationManagerDelegate {
    // 위치 권한 상태 변경 시 호출
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("위치 권한이 거부되었습니다.")
        default:
            break
        }
    }
    
   // 위치 업데이트 시 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
        locationManager.stopUpdatingLocation()  // 한 번 받아오면 업데이트 중단
    }
    // 위치 업데이트 실패 시 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 업데이트 실패: \(error.localizedDescription)")
    }
}
