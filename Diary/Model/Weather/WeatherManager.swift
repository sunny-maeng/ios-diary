//
//  WeatherManager.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import UIKit

final class WeatherManager {
   
    private let locationManager: LocationManager
    private let networkSessionManager: NetworkSessionManager

    private var location: (latitude: Double, longitude: Double) {
        locationManager.fetchLocation()
    }

    init(locationManager: LocationManager, networkSessionManager: NetworkSessionManager) {
        self.locationManager = locationManager
        self.networkSessionManager = networkSessionManager
    }
    
    func fetchWeatherInfo(completion: @escaping (WeatherInfo?) -> Void) throws {
        let url = try APIEndpoints.generateCurrentWeatherDataUrl(
            at: APIEndpoints.Location(latitude: location.latitude, longitude: location.longitude))

        networkSessionManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    guard let decodedWeather = DecodeManager.decodeWeatherData(data)?.toDomain() else {
                        completion(nil)
                        return
                    }
                    completion(decodedWeather)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchWeatherIcon(icon: String, completion: @escaping (UIImage?) -> Void) throws {
        let url = try APIEndpoints.generateWeatherIconUrl(iconName: icon)
        
        networkSessionManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
