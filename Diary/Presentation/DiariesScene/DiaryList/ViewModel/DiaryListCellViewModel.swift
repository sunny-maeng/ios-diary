//
//  DiaryListCellViewModel.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

struct DiaryListCellViewModel {

    let title: String
    let date: String
    let preview: String
    let weatherIconName: String?
    var id: UUID
}

extension DiaryListCellViewModel {

    init(diaryInfo: DiaryInfo) {
        self.title = diaryInfo.title
        self.date = diaryInfo.createdAt.localizedDateFormat
        self.preview = diaryInfo.body
        self.weatherIconName = diaryInfo.weather?.icon
        self.id = diaryInfo.id
    }
}
