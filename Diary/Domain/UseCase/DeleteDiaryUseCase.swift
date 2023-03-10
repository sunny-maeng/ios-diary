//
//  DeleteDiaryUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultDeleteDiariesUseCase: DeleteDiaryUseCase {

    private let diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository = DefaultDiariesRepository()) {
        self.diariesRepository = diariesRepository
    }

    func delete(diaryInfo: DiaryInfo) {
        diariesRepository.delete(diaryInfo: diaryInfo)
    }
}
