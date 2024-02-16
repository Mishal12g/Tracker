//
//  CatigoriesStorage.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class CategoriesStorageService {
    //MARK: - Static properties
    static let didChangeNotification = Notification.Name("CategoriesStorageServiceDidChange")
    static let shared = CategoriesStorageService()
    
    //MARK: - Privates properties
    private(set) var categories: [TrackerCategory] = []
    
    //MARK: - Public methods
    func addCategory(_ category: TrackerCategory) {
        categories.append(category)
        NotificationCenter.default.post(name: CategoriesStorageService.didChangeNotification,
                                        object: self,
                                        userInfo: ["Categories" : categories.self])
    }
    
    func addTracker(_ categoryName: String, _ tracker: Tracker) {
        categories = categories.map { category in
            var array = category.trackers
            array.append(tracker)
            
            return TrackerCategory(title: category.title,
                                   trackers: array)
        }
        
        NotificationCenter.default.post(name: CategoriesStorageService.didChangeNotification,
                                        object: self,
                                        userInfo: ["Categories" : categories.self])
    }
}
