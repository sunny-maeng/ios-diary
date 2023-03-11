//
//  UpdateDiaryUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultUpdateDiaryUseCase: UpdateDiaryUseCase {

    private let diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository) {
        self.diariesRepository = diariesRepository
    }

    func update(diaryInfo: DiaryInfo) {
        diariesRepository.update(diaryInfo: diaryInfo)
    }
}
