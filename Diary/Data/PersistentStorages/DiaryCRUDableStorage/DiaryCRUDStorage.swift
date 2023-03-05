//
//  DiaryCRUDStorage.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol DiaryCRUDStorage {

    func save(_ diaryInfo: DiaryInfo)
    func fetchDiaries(completion: @escaping(Result<[DiaryInfo], Error>) -> Void)
    func update(_ diaryInfo: DiaryInfo)
    func delete(_ diaryInfo: DiaryInfo)
    func deleteAllNoDataDiaries()
    
}
