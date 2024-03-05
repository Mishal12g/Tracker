//
//  TrackerStore.swift
//  Tracker
//
//  Created by mihail on 06.02.2024.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCD> = {
        let fetchRequest = TrackerCD.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCD.category?.title, ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "category.title",
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
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

extension TrackerStore {
    var isEmpty: Bool {
        fetchedResultsController.sections?.isEmpty ?? true
    }
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerManagedObject = fetchedResultsController.object(at: indexPath)
        return convert(managedObject: trackerManagedObject)
    }
    
    func getTracker(id: UUID) -> Tracker? {
        let fetchTrackersCD = TrackerCD.fetchRequest()
        fetchTrackersCD.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        guard let tracker = try? context.fetch(fetchTrackersCD).first else { return nil}
        
        return convert(managedObject: tracker)
    }
    
    func category(at indexPath: IndexPath) -> TrackerCategory? {
        let trackerManagedObject = fetchedResultsController.object(at: indexPath)
        
        let fetchCategory = CategoryCD.fetchRequest()
        fetchCategory.predicate = NSPredicate(format: "title == %@", trackerManagedObject.category?.title ?? "")
        
        guard 
            let category = try? context.fetch(fetchCategory).first,
            let id = category.id,
            let title = category.title
        else { return nil }
        
        return TrackerCategory(id: id, title: title, trackers: [])
    }
    
    func header(at indexPath: IndexPath) -> String? {
        fetchedResultsController.sections?[indexPath.section].name
    }
    
    func convert(managedObject: TrackerCD) -> Tracker? {
        guard
            let id = managedObject.id,
            let name = managedObject.name,
            let emoji = managedObject.emoji,
            let hexColor = managedObject.hexColor,
            let scheduleString = managedObject.schedule
            
        else { return nil }
        return Tracker(
            id: id,
            name: name,
            color: ColorMarshall.decode(hexColor: hexColor),
            emoji: emoji,
            schedule: WeekDayMarshall.decode(weekDays: scheduleString), 
            isPinned: managedObject.isPinned
        )
    }
    
    func addTracker(tracker: Tracker, category: TrackerCategory) throws {
        let trackerCD = TrackerCD(context: context)
        trackerCD.id = tracker.id
        trackerCD.hexColor = ColorMarshall.encode(color: tracker.color)
        trackerCD.schedule = WeekDayMarshall.encode(weekDays: tracker.schedule ?? Weekday.allCases)
        trackerCD.emoji = tracker.emoji
        trackerCD.name = tracker.name
        
        let fetchRequest = CategoryCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
        
        guard let categoryCD = try? context.fetch(fetchRequest).first else {
            return
        }
        
        trackerCD.category = categoryCD
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func pinnedTracker(trackerID: UUID, shouldPin: Bool) {
        let fetchTrackersCD = TrackerCD.fetchRequest()
        
        fetchTrackersCD.predicate = NSPredicate(format: "id == %@",
                                                trackerID as CVarArg)
        
        guard let trackerCD = try? context.fetch(fetchTrackersCD).first else { return }
        
        trackerCD.isPinned = shouldPin
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    func deleteTracker(trackerID: UUID?) {
        guard let trackerID = trackerID else { return }
        let fetchTrackersCD = TrackerCD.fetchRequest()
        fetchTrackersCD.predicate = NSPredicate(format: "id == %@",
                                         trackerID as CVarArg)
        
        guard let trackerCD = try? context.fetch(fetchTrackersCD).first else { return }
        
        context.delete(trackerCD)
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }

    func updateTracker(tracker: Tracker, category: TrackerCategory, trackerID: UUID) {
        let fetchTrackersCD = TrackerCD.fetchRequest()
        fetchTrackersCD.predicate = NSPredicate(format: "id == %@",
                                         trackerID as CVarArg)
        
        guard let trackerCD = try? context.fetch(fetchTrackersCD).first else { return }
        
        let fetchCategoriesCD = CategoryCD.fetchRequest()
        fetchCategoriesCD.predicate = NSPredicate(format: "id == %@",
                                                category.id as CVarArg)
        
        guard let categoryCD = try? context.fetch(fetchCategoriesCD).first else { return }
        
        trackerCD.category = categoryCD
        trackerCD.emoji = tracker.emoji
        trackerCD.hexColor = ColorMarshall.encode(color: tracker.color)
        trackerCD.name = tracker.name
        trackerCD.schedule = WeekDayMarshall.encode(weekDays: tracker.schedule)
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }

    func filter(by date: Date, and searchText: String) {
        var predicates: [NSPredicate] = []
        let weekDay = Calendar.current.component(.weekday, from: date)
        let weekDayIndex = String(weekDay)
        
        if searchText.isEmpty {
            predicates.append(
                NSPredicate(format: "%K CONTAINS[cd] %@", "schedule", weekDayIndex)
            )
        }
        
        if !searchText.isEmpty {
            predicates.append(
                NSPredicate(format: "%K CONTAINS[cd] %@", "name", searchText)
            )
        }
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        do{
            try fetchedResultsController.performFetch()
            
            delegate?.didUpdate()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
