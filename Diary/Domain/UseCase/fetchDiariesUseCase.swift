//
//  FetchDiariesUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

final class DefaultFetchDiaryUseCase: FetchDiariesUseCase {

    private let diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository = DefaultDiariesRepository()) {
        self.diariesRepository = diariesRepository
    }

    func fetch(completion: @escaping (Result<[DiaryInfo], Error>) -> Void) {
        diariesRepository.fetchDiaries { result in
            completion(result)
        }
    }

}
