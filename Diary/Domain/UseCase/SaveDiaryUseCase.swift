//
//  SaveDiaryUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

final class DefaultFetchDiariesUseCase: SaveDiaryUseCase {

    private let diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository) {
        self.diariesRepository = diariesRepository
    }

    func save(diaryInfo: DiaryInfo) {
        diariesRepository.save(diaryInfo: diaryInfo)
    }

}
