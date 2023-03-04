//
//  CoreDataDiaryCRUDableStorage.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation
import CoreData

final class CoreDataDiaryInfoCRUDStorage {

    private let coreDataStorage: CoreDataStorage
    private let dataMapping: DataMapping

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared,
         dataMapping: DataMapping = DataMapping()) {
        self.coreDataStorage = coreDataStorage
        self.dataMapping = dataMapping
    }
}

extension CoreDataDiaryInfoCRUDStorage: DiaryInfoCRUDableStorage {

    func save(_ diaryInfo: DiaryInfo) {
        guard searchDiary(using: diaryInfo.id).first == nil else { return }

        let diaryEntity = dataMapping.domainToCoreDataEntity(from: diaryInfo,
                                                             coreStorageContext: coreDataStorage.context)
        coreDataStorage.saveContext()
    }

    func fetchDiaries() -> [DiaryInfo] {
        deleteAllNoDataDiaries()

        var diaryList: [DiaryInfo] = []
        let request = Diary.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: Constant.createdAt, ascending: false)]

        do {
            let fetchedData = try coreDataStorage.context.fetch(request)
            fetchedData.forEach { diaryEntity in
                diaryList.append(dataMapping.coreDataEntityToDomain(from: diaryEntity))
            }
        } catch {
            print(error.localizedDescription)
        }

        return diaryList
    }

    func update(_ diaryInfo: DiaryInfo) {
        guard let fetchedData = searchDiary(using: diaryInfo.id).first else {
            return
        }

        fetchedData.title = diaryInfo.title
        fetchedData.body = diaryInfo.body

        coreDataStorage.saveContext()
    }

    func delete(_ diaryInfo: DiaryInfo) {
        guard let diaryWillDelete = searchDiary(using: diaryInfo.id).first else {
            return
        }

        coreDataStorage.context.delete(diaryWillDelete)
        coreDataStorage.saveContext()
    }

    func deleteAllNoDataDiaries() {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: Constant.diaryContainer)
        let predicateOfTitle = NSPredicate(format: Constant.titleChecking, Constant.empty)
        let predicateOfBody = NSPredicate(format: Constant.bodyChecking, Constant.empty)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateOfTitle,
                                                                                predicateOfBody])

        do {
            let noDataDiaries = try coreDataStorage.context.fetch(request)
            noDataDiaries.forEach { coreDataStorage.context.delete($0) }
        } catch {
            print(error.localizedDescription)
        }

        coreDataStorage.saveContext()
    }

    func deleteAllDiaries() {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: Constant.diaryContainer)

        do {
            let fetchedData = try coreDataStorage.context.fetch(request)
            fetchedData.forEach { coreDataStorage.context.delete($0) }
        } catch {
            print(error.localizedDescription)
        }

        coreDataStorage.saveContext()
    }

    private func searchDiary(using id: UUID) -> [Diary] {
        let request: NSFetchRequest<Diary> = NSFetchRequest(entityName: Constant.diaryContainer)
        request.predicate = .init(format: Constant.idChecking, id.uuidString)

        do {
            return try coreDataStorage.context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }

        return []
    }

}

extension CoreDataDiaryInfoCRUDStorage {

    private enum Constant {
        static let diaryContainer = "Diary"
        static let idChecking = "id = %@"
        static let titleChecking = "title = %@"
        static let bodyChecking = "body = %@"
        static let createdAt = "createdAt"
        static let empty = ""
    }

}
