//
//  DefaultWeatherIconRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultWeatherRepository {

    private let weatherAPI: WeatherAPI

    init(weatherAPI: WeatherAPI = DefaultWeatherAPI(locationManager: DefaultLocationManager(),
                                                    networkService: DefaultNetworkService())) {
        self.weatherAPI = weatherAPI
    }
}

extension DefaultWeatherRepository: WeatherRepository {

    func fetchWeatherInfo(completion: @escaping (Result<WeatherInfo, Error>) -> Void) {
        weatherAPI.fetchWeatherInfoDto { (result: Result<WeatherResponseDTO, NetworkError>)  in
            switch result {
            case .success(let weatherResponseDto):
                DispatchQueue.main.async {
                    completion(.success(weatherResponseDto.toDomain()))
                }
            case .failure(let error):
                completion(.failure(error as Error))
            }
        }
    }

    func fetchWeatherIcon(iconName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        weatherAPI.fetchWeatherIconData(iconName: iconName) { (result: Result<Data, NetworkError>)  in
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
    }
}
