//
//  DataStore.swift
//  Tracker
//
//  Created by mihail on 08.02.2024.
//

//import Foundation
//import CoreData
//
//final class DataStore {
//    static let shared = DataStore()
//    
//    private let model = "TrackerDataModel"
//    private lazy var container: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: model)
//        
//        container.loadPersistentStores { description, error in
//            if let error = error as NSError? {
//                fatalError("\(error) \(error.userInfo)")
//            }
//        }
//        
//        return container
//    }()
//    
//    private var context: NSManagedObjectContext {
//        container.viewContext
//    }
//    
//    var managedObjectContext: NSManagedObjectContext {
//        self.context
//    }
//}
