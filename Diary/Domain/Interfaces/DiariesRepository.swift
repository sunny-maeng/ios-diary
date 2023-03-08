//
//  DiariesRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol DiariesRepository {

    func fetchDiaries(completion: @escaping (Result<[DiaryInfo], Error>) -> Void)
    func save(diaryInfo: DiaryInfo)
    func update(diaryInfo: DiaryInfo)
    func delete(diaryInfo: DiaryInfo)
}
