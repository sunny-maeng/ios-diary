//
//  DefaultWeatherInfoRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultWeatherInfoRepository {

    private let locationManager: LocationManager
    private let networkService: NetworkService

    init(locationManager: LocationManager = DefaultLocationManager(),
         networkService: NetworkService = DefaultNetworkService()) {
        self.locationManager = locationManager
        self.networkService = networkService
    }

}

extension DefaultWeatherInfoRepository: WeatherInfoRepository {

    func fetchWeatherInfo(completion: @escaping (Result<WeatherInfo, Error>) -> Void) {
        let location = locationManager.fetchLocation()

        networkService.request(endpoint: APIEndpoints.getCurrentWeatherData(at: location)) {
            (result: Result<Data, NetworkError>)  in

            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    guard let decodedWeather = DecodeManager.decodeWeatherData(data) else {
                        return
                    }
                    completion(.success(decodedWeather.toDomain()))
                }
            case .failure(let error):
                completion(.failure(error as Error))
            }
        }
    }

}
