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
    
    private var pinnedTrackers: [Tracker]? {
        guard 
            let trackersCD = isPinnedfetchedResultsController.fetchedObjects
        else { return nil}
        
        return trackersCD.compactMap({ convert(managedObject: $0) })
    }
    
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCD> = {
        let fetchRequest = TrackerCD.fetchRequest()
        
        let pinnedSortDescriptor = NSSortDescriptor(keyPath: \TrackerCD.isPinned, ascending: false)
        // Затем сортируем по категории (если требуется)
        let categorySortDescriptor = NSSortDescriptor(keyPath: \TrackerCD.category?.title, ascending: true)
        
        fetchRequest.sortDescriptors = [pinnedSortDescriptor, categorySortDescriptor]
        
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
    
    private lazy var isPinnedfetchedResultsController: NSFetchedResultsController<TrackerCD> = {
        let fetchTrackerCD = TrackerCD.fetchRequest()
        fetchTrackerCD.predicate = NSPredicate(format: "isPinned == YES")
        fetchTrackerCD.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCD.name, ascending: true)
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchTrackerCD,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
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
    
    var pinnedTrackersIsEmpty: Bool {
        pinnedTrackers?.isEmpty ?? true
    }
    
    var numberOfSections: Int {
        if !pinnedTrackersIsEmpty {
            return (isPinnedfetchedResultsController.sections?.count ?? 0) + 1
        }
        
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if !pinnedTrackersIsEmpty {
            if section == 0 {
                return isPinnedfetchedResultsController.fetchedObjects?.count ?? 0
            } else {
                return fetchedResultsController.sections?[section - 1].numberOfObjects ?? 0
            }
        }
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        if !pinnedTrackersIsEmpty {
            if indexPath.section == 0 {
                return convert(managedObject: isPinnedfetchedResultsController.object(at: indexPath))
            } else {
                let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                let trackerCD = fetchedResultsController.object(at: newIndexPath)
                return convert(managedObject: trackerCD)
            }
        }
        
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
        if !pinnedTrackersIsEmpty {
            if indexPath.section == 0 {
                return NSLocalizedString("pinned.category", comment: "")
            } else {
                return fetchedResultsController.sections?[indexPath.section - 1].name
            }
        }
        
        return fetchedResultsController.sections?[indexPath.section].name
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
        trackerCD.isPinned = tracker.isPinned
        
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
    
    func pinnedTracker(indexPath: IndexPath) {
        if !pinnedTrackersIsEmpty {
            if indexPath.section == 0 {
                let pinnedTracker = isPinnedfetchedResultsController.object(at: indexPath)
                pinnedTracker.isPinned.toggle()
            } else {
                let newIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
                let trackerCD = fetchedResultsController.object(at: newIndexPath)
                trackerCD.isPinned.toggle()
            }
        } else {
            let trackerCD = fetchedResultsController.object(at: indexPath)
            trackerCD.isPinned.toggle()
        }
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
