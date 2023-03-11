//
//  DefaultDiariesRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

final class DefaultDiariesRepository {

    private let diaryCRUDStorage: DiaryCRUDStorage

    init(diaryCRUDStorage: DiaryCRUDStorage) {
        self.diaryCRUDStorage = diaryCRUDStorage
    }
}

extension DefaultDiariesRepository: DiariesRepository {

    func fetchDiaries(completion: @escaping (Result<[DiaryInfo], Error>) -> Void) {
        diaryCRUDStorage.fetchDiaries { result in
            completion(result)
        }
    }

    func save(diaryInfo: DiaryInfo) {
        diaryCRUDStorage.save(diaryInfo)
    }

    func update(diaryInfo: DiaryInfo) {
        diaryCRUDStorage.update(diaryInfo)
    }

    func delete(diaryInfo: DiaryInfo) {
        diaryCRUDStorage.delete(diaryInfo)
    }
}
