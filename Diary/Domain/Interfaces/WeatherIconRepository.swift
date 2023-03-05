//
//  WeatherIconRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

protocol WeatherIconRepository {

    func fetchWeatherIcon(icon: String, completion: @escaping (Result<Data, Error>) -> Void)

}
