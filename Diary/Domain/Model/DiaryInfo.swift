//
//  DiaryInfo.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import Foundation

struct DiaryInfo: Hashable {
    
    var title: String
    var body: String
    let createdAt: Date
    let weather: WeatherInfo?
    var id = UUID()
    var createdDate: String { createdAt.localizedDateFormat } // ⭐️MVVM적용시 이동
}
