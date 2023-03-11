//
//  DefaultWeatherIconRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultWeatherRepository {

    private let weatherAPI: WeatherAPI
    private let weatherIconCache: CacheStorage

    init(weatherAPI: WeatherAPI, weatherIconCache: CacheStorage) {
        self.weatherAPI = weatherAPI
        self.weatherIconCache = weatherIconCache
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
        weatherAPI.fetchWeatherIconData(iconName: iconName) { [weak self] (result: Result<Data, NetworkError>)  in
            let cacheKey: NSString = NSString(string: iconName)
            
            if let cachedIcon: NSData = self?.weatherIconCache.cacheIcon(cacheKey: cacheKey) {
                DispatchQueue.main.async {
                    completion(.success(Data(cachedIcon)))
                }
            } else {
                switch result {
                case .success(let iconData):
                    self?.weatherIconCache.store(cacheKey: NSString(string: iconName), icon: NSData(data: iconData))
                    DispatchQueue.main.async {
                        completion(.success(iconData))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError as Error))
                }
            }
        }
    }
}
