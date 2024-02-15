//
//  NSPersistionContainer + extension.swift
//  Tracker
//
//  Created by mihail on 08.02.2024.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    static func create(for model: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: model)
        container.loadPersistentStores {
            if let error = $1 {
                assertionFailure("Error loading the persistent container: \(error)")
            }
        }
        return container
    }
}
