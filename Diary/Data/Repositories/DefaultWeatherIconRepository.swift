//
//  DefaultWeatherIconRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultWeatherIconRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

}

extension DefaultWeatherIconRepository: WeatherIconRepository {

    func fetchWeatherIcon(icon: String, completion: @escaping (Result<Data, Error>) -> Void) {
        networkService.request(endpoint: APIEndpoints.getWeatherIcon(iconName: icon)) {
            (result: Result<Data, NetworkError>)  in
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
    }
}

