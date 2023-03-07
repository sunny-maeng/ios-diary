//
//  UpdateDiaryUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultUpdateDiariesUseCase: UpdateDiaryUseCase {

    private let diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository = DefaultDiariesRepository()) {
        self.diariesRepository = diariesRepository
    }

    func update(diaryInfo: DiaryInfo) {
        diariesRepository.update(diaryInfo: diaryInfo)
    }

}
