//
//  WeatherAPI.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

protocol WeatherAPI {

    func fetchWeatherInfoDto(completion: @escaping (Result<WeatherResponseDTO, NetworkError>) -> Void)
    func fetchWeatherIconData(iconName: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class DefaultWeatherAPI {

    private let locationManager: LocationManager
    private let networkService: NetworkService

    init(locationManager: LocationManager, networkService: NetworkService) {
        self.locationManager = locationManager
        self.networkService = networkService
    }
}

extension DefaultWeatherAPI: WeatherAPI {

    func fetchWeatherInfoDto(completion: @escaping (Result<WeatherResponseDTO, NetworkError>) -> Void) {
        let location = locationManager.fetchLocation()

        networkService.request(endpoint: APIEndpoints.getCurrentWeatherData(at: location)) {
            (result: Result<Data, NetworkError>)  in

            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let weatherResponseDto = DecodeManager.decodeWeatherData(data, to: WeatherResponseDTO.self) {
                        completion(.success(weatherResponseDto))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchWeatherIconData(iconName: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        networkService.request(endpoint: APIEndpoints.getWeatherIcon(iconName: iconName)) { result  in
            completion(result)
        }
    }
}
