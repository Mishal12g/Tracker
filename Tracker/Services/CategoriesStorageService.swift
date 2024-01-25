//
//  CatigoriesStorage.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class CategoriesStorageService {
    static let didChangeNotification = Notification.Name("CategoriesStorageServiceDidChange")
    static let shared = CategoriesStorageService()
    
    private(set) var categories: [TrackerCategory] = [TrackerCategory(title: "Покушать", trackers: []),
                                                      TrackerCategory(title: "Бег", trackers: []),
                                                      TrackerCategory(title: "Важное", trackers: []),
                                                      TrackerCategory(title: "Мусор", trackers: []),
                                                      TrackerCategory(title: "Зарядка", trackers: []),
                                                      TrackerCategory(title: "Чтение", trackers: [])]
    
    func addCategory(_ category: TrackerCategory) {
        
    }
    
    func addTracker(_ categoryName: String, _ tracker: Tracker) {
        if let i = categories.firstIndex(where: {
            $0.title == categoryName
        }) {
            categories[i].trackers.append(tracker)
            NotificationCenter.default.post(name: CategoriesStorageService.didChangeNotification,
                                            object: self,
                                            userInfo: ["Categories" : categories.self])
        }
    }
}
