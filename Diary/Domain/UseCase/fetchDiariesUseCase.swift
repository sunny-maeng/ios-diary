//
//  FetchDiariesUseCase.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

final class DefaultFetchDiariesUseCase: FetchDiariesUseCase {

    private let diariesRepository: DiariesRepository

    init(diariesRepository: DiariesRepository) {
        self.diariesRepository = diariesRepository
    }

    func fetch(completion: @escaping (Result<[DiaryInfo], Error>) -> Void) {
        diariesRepository.fetchDiaries { result in
            completion(result)
        }
    }
}
