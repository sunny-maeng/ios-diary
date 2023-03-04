//
//  CoreDataStorage.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation
import CoreData

final class CoreDataStorage {

    static let shared: CoreDataStorage = CoreDataStorage()

    private init() {}

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.diaryContainer)

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension CoreDataStorage {

    private enum Constant {
        static let diaryContainer = "Diary"
    }
    
}
