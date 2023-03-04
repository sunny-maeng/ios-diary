//
//  DataMapping.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation
import CoreData

struct DataMapping {

    func coreDataEntityToDomain(from coreDataEntity: Diary) -> DiaryInfo {
        return .init(title: coreDataEntity.title ?? "",
                     body: coreDataEntity.body ?? "",
                     createdAt: coreDataEntity.createdAt ?? Date(),
                     weather: coreDataEntity.weather?.weatherInfo,
                     id: coreDataEntity.id ?? UUID())
    }

    func domainToCoreDataEntity(from domain: DiaryInfo, coreStorageContext: NSManagedObjectContext) -> Diary {
        let diaryEntity = Diary(context: coreStorageContext)
        diaryEntity.title = domain.title
        diaryEntity.body = domain.body
        diaryEntity.createdAt = domain.createdAt
        diaryEntity.id = domain.id

        let weatherEntity = Weather(context: coreStorageContext)
        weatherEntity.main = domain.weather?.main
        weatherEntity.icon = domain.weather?.icon
        diaryEntity.weather = weatherEntity

        return diaryEntity
    }

}
