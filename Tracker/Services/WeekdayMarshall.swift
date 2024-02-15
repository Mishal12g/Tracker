//
//  WeekdayMarshall.swift
//  Tracker
//
//  Created by mihail on 08.02.2024.
//

import Foundation

final class WeekDayMarshall {
    static func encode(weekDays: [Weekday]) -> String {
        weekDays
            .map({ "\($0.rawValue)" })
            .joined(separator: ", ")
    }
    
    static func decode(weekDays: String) -> [Weekday] {
        weekDays
            .components(separatedBy: ", ")
            .compactMap({ Int($0) })
            .compactMap({ Weekday(rawValue: $0) })
    }
}
