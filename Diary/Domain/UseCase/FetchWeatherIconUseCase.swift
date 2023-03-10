//
//  FetchWeatherIconUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

final class DefaultFetchWeatherIconUseCase: FetchWeatherIconUseCase {

    private let weatherRepository: WeatherRepository

    init(weatherRepository: WeatherRepository = DefaultWeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    func fetchWeatherIcon(iconName: String, completion: @escaping (Result<Data, Error>) -> Void ) {
        weatherRepository.fetchWeatherIcon(iconName: iconName) { result in
            completion(result)
        }
    }
}
