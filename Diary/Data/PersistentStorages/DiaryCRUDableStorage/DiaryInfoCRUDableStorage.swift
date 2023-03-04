//
//  DiaryCRUDableStorage.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol DiaryInfoCRUDableStorage {

    func save(_ diaryInfo: DiaryInfo)
    func fetchDiaries() -> [DiaryInfo]
    func update(_ diaryInfo: DiaryInfo)
    func delete(_ diaryInfo: DiaryInfo)
    func deleteAllNoDataDiaries()
    
}
