//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by 정유진 on 3/20/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "WeatherApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error{
                fatalError("CoreData 로드 실패: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
}
