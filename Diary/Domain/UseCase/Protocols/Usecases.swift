//
//  UseCases.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol FetchDiariesUseCase {

    func fetch(completion: @escaping (Result<[DiaryInfo], Error>) -> Void)
}

protocol SaveDiaryUseCase {

    func save(diaryInfo: DiaryInfo)
}

protocol UpdateDiaryUseCase {

    func update(diaryInfo: DiaryInfo)
}

protocol DeleteDiaryUseCase {

    func delete(diaryInfo: DiaryInfo)
}

protocol FetchWeatherIconUseCase {

    func fetchWeatherIcon(iconName: String, completion: @escaping (Result<Data, Error>) -> Void )
}

protocol FetchWeatherUseCase {

    func fetchWeather(completion: @escaping (Result<WeatherInfo, Error>) -> Void )
}
