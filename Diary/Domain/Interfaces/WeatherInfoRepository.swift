//
//  WeatherInfoRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

protocol WeatherInfoRepository {

    func fetchWeatherInfo(completion: @escaping (Result<WeatherInfo, Error>) -> Void)

}
