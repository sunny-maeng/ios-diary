//
//  DiaryRegistrationViewModel.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

struct DiaryRegistrationViewModel {

    private var diaryInfo: DiaryInfo {
        didSet {
            updateDiaryUseCase.update(diaryInfo: diaryInfo)
        }
    }
    var navigationTitle: String { return diaryInfo.createdAt.localizedDateFormat }
    let titlePlaceHolder: String = "일기 제목"
    let bodyPlaceHolder: String = "일기 내용"

    private let saveDiaryUseCase: SaveDiaryUseCase
    private let updateDiaryUseCase: UpdateDiaryUseCase

    init(diaryInfo: DiaryInfo,
         saveDiaryUseCase: SaveDiaryUseCase = DefaultFetchDiariesUseCase(),
         updateDiaryUseCase: UpdateDiaryUseCase = DefaultUpdateDiaryUseCase()) {
        self.diaryInfo = diaryInfo
        self.saveDiaryUseCase = saveDiaryUseCase
        self.updateDiaryUseCase = updateDiaryUseCase
    }

    func saveDiary() {
        saveDiaryUseCase.save(diaryInfo: diaryInfo)
    }

    mutating func updateDiary(title: String, body: String) {
        diaryInfo.title = title
        diaryInfo.body = body
    }
}
