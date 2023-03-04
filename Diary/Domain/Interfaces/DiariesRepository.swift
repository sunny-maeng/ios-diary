//
//  DiariesRepository.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol DiariesRepository {

    func fetchDiaries(completion: @escaping (Result<[DiaryInfo], Error>) -> Void)

}
