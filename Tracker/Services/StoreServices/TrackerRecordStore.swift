//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by mihail on 06.02.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    //convert
    private func convert(recordCD: RecordCD) -> TrackerRecord? {
        guard let trackerId = recordCD.trackerId,
              let completedDate = recordCD.completedDate else { return nil }
        
        return TrackerRecord(
            trackerId: trackerId,
            completedDate: completedDate
        )
    }
}

extension TrackerRecordStore {
    func isTrackerCompletedToday(by trackerId: UUID, and currentDate: Date) -> Bool {
        fetchRecord(by: trackerId, and: currentDate) != nil
    }
    
    func completedTrackers(by trackerID: UUID) -> Int {
        let fetchRequest = RecordCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@", trackerID as CVarArg)
        
        guard let objects = try? context.fetch(fetchRequest) else { return 0 }
        
        return objects.count
    }
    
    func fetchRecord(by trackerID: UUID, and currentDate: Date) -> TrackerRecord? {
        let fetchRequest = RecordCD.fetchRequest()
        let datePredicate = NSPredicate(format: "completedDate == %@", currentDate as CVarArg)
        let trackerIDPredicate = NSPredicate(format: "trackerId == %@", trackerID as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            datePredicate,
            trackerIDPredicate,
        ])
        
        guard let recordCD = try? context.fetch(fetchRequest).first else { return nil }
       
        return convert(recordCD: recordCD)
    }
    
    func add(_ record: TrackerRecord) {
        let recordCD = RecordCD(context: context)
        recordCD.trackerId = record.trackerId
        recordCD.completedDate = record.completedDate
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ record: TrackerRecord) {
        let request = RecordCD.fetchRequest()
        let datePredicate = NSPredicate(format: "completedDate == %@", record.completedDate as CVarArg)
        let trackerIdPredicate = NSPredicate(format: "trackerId == %@", record.trackerId as CVarArg)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [datePredicate, trackerIdPredicate])
        guard
            let recordManagedObject = try? context.fetch(request).first
        else { return }
        context.delete(recordManagedObject)
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
