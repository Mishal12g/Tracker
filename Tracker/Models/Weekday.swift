//
//  Weekday.swift
//  Tracker
//
//  Created by mihail on 31.01.2024.
//

import Foundation

enum Weekday: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var title: String {
        switch self {
        case .monday:
            return NSLocalizedString("weekday.monday", comment: "")
        case .tuesday:
            return NSLocalizedString("weekday.tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("weekday.wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("weekday.thursday", comment: "")
        case .friday:
            return NSLocalizedString("weekday.friday", comment: "")
        case .saturday:
            return NSLocalizedString("weekday.saturday", comment: "")
        case .sunday:
            return NSLocalizedString("weekday.sunday", comment: "")
        }
    }
    
    var short: String {
        switch self {
        case .monday:
            return NSLocalizedString("weekday.monday.short", comment: "")
        case .tuesday:
            return NSLocalizedString("weekday.tuesday.short", comment: "")
        case .wednesday:
            return NSLocalizedString("weekday.wednesday.short", comment: "")
        case .thursday:
            return NSLocalizedString("weekday.thursday.short", comment: "")
        case .friday:
            return NSLocalizedString("weekday.friday.short", comment: "")
        case .saturday:
            return NSLocalizedString("weekday.saturday.short", comment: "")
        case .sunday:
            return NSLocalizedString("weekday.sunday.short", comment: "")
        }
    }
}
