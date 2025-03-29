//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by 정유진 on 3/20/25.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var persistentContainer : NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // MARK: - 검색어 저장
    func saveSearchQuery(_ query: String) {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let newSearch = RecentSearch(context: context)
        newSearch.query = query
        newSearch.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            print("CoreData 저장 오류: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 최근 검색어 가져오기
    func fetchRecentSearches() {
        
    }
    
}
