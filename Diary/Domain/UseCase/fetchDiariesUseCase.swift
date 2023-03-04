//
//  FetchDiariesUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

final class DefaultSaveDiaryUseCase: SaveDiaryUseCase {

    var diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository) {
        self.diariesRepository = diariesRepository
    }

    func save() {
        diariesRepository.save()
    }

}
