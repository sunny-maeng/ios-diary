//
//  FetchWeatherUsecase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

final class DefaultFetchWeatherUseCase: FetchWeatherUseCase {

    private let weatherRepository: WeatherRepository

    init(weatherRepository: WeatherRepository = DefaultWeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    func fetchWeather(completion: @escaping (Result<WeatherInfo, Error>) -> Void ) {
        weatherRepository.fetchWeatherInfo { result in
            completion(result)
        }
    }
}
