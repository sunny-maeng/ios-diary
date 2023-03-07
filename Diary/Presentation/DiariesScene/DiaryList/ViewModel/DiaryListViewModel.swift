//
//  DiaryListViewModel.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

final class DiaryListViewModel {

    private var diary: [DiaryInfo] = []


    func aa() {
        CoreDataDiaryCRUDStorage().fetchDiaries { [weak self] result in
            switch result {
            case .success(let diaries):
                self?.diary = diaries
            case .failure(let error):
                print(error)
            }
        }
    }
}
