//
//  WeatherIconRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

protocol WeatherRepository {

    func fetchWeatherInfo(completion: @escaping (Result<WeatherInfo, Error>) -> Void)
    func fetchWeatherIcon(iconName: String, completion: @escaping (Result<Data, Error>) -> Void)
}
