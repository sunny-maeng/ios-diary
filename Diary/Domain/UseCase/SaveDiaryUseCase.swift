//
//  SaveDiaryUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

final class DefaultSaveDiaryUseCase: SaveDiaryUseCase {

    private let diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository = DefaultDiariesRepository()) {
        self.diariesRepository = diariesRepository
    }

    func save(diaryInfo: DiaryInfo) {
        diariesRepository.save(diaryInfo: diaryInfo)
    }
}
