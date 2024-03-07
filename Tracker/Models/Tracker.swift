//
//  Tracker.swift
//  Tracker
//
//  Created by mihail on 15.01.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Array<Weekday>?
    let isPinned: Bool
}
