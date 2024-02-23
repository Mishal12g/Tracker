//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by mihail on 06.02.2024.
//

import Foundation
import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    private weak var delegate: StoreDelegate?
    
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    private lazy var fetchResultsController: NSFetchedResultsController<CategoryCD> = {
        let fetchRequest = CategoryCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \CategoryCD.objectID, ascending: true)
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            frc.delegate = self
            try frc.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
        
        return frc
    }()
    
    init(delegate: StoreDelegate? = nil) {
        self.delegate = delegate

    }
}

extension TrackerCategoryStore {
    func objects() -> [TrackerCategory] {
        guard let categoriesCD = fetchResultsController.fetchedObjects else { return [] }
        
        let categories = categoriesCD.map { convert(categoryCD: $0)}
        
        return categories
    }
    
    func addCategory(category: TrackerCategory) {
        let categoryCD = CategoryCD(context: context)
        
        categoryCD.id = category.id
        categoryCD.title = category.title
        categoryCD.addToTrackers([])
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func convert(categoryCD: CategoryCD) -> TrackerCategory {
        TrackerCategory(
            id: categoryCD.id ?? UUID(), 
            title: categoryCD.title ?? "",
            trackers: []
        )
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
