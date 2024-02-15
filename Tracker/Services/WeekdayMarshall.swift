//
//  WeekdayMarshall.swift
//  Tracker
//
//  Created by mihail on 08.02.2024.
//

import Foundation

final class WeekDayMarshall {
    static func encode(weekDays: [Weekday]?) -> String? {
        guard let weekDays = weekDays else { return nil }
       
        let str = weekDays.map({ "\($0.rawValue)" })
            .joined(separator: ", ")
        
        return str
    }
    
    static func decode(weekDays: String) -> [Weekday] {
        weekDays
            .components(separatedBy: ", ")
            .compactMap({ Int($0) })
            .compactMap({ Weekday(rawValue: $0) })
    }
}
