//
//  DataMapping.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation
import CoreData

struct DataMapping {

    func coreDataDiaryEntityToDomain(from coreDataEntity: Diary) -> DiaryInfo {
        return .init(title: coreDataEntity.title ?? "",
                     body: coreDataEntity.body ?? "",
                     createdAt: coreDataEntity.createdAt ?? Date(),
                     weather: coreDataWeatherEntityToDomain(from: coreDataEntity.weather),
                     id: coreDataEntity.id ?? UUID())
    }

    func domainToCoreDataDairyEntity(from domain: DiaryInfo, coreStorageContext: NSManagedObjectContext) -> Diary {
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

    func coreDataWeatherEntityToDomain(from weatherEntity: Weather?) -> WeatherInfo? {
        guard let main = weatherEntity?.main,
              let icon = weatherEntity?.icon else {
            return nil
        }

        return .init(main: main, icon: icon)
    }
}
