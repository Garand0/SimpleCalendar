//
//  CalendarModel.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import Foundation

enum WeekDay: Int {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1

    var index: Int {
        switch self {
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        case .sunday:
            return 7
        }
    }
}

struct CalendarModel {
    let startWeekDay: WeekDay
    let dates: [Date]
}

struct CalendarDateFormatter {
    static func monthName(for date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL YYYY"
        return formatter.string(from: date).stringWithCapitalizedFirstCharacter()
    }
    
    static func dateDayNumberText(for date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date).stringWithCapitalizedFirstCharacter()
    }

    static func dateDayNumber(for date: Date?) -> Int? {
        guard let date = date else { return nil }
        return Calendar.current.component(.day, from: date)
    }

    static func isMonday(for date: Date) -> Bool { Calendar.current.component(.weekday, from: date) == 2 }

    static func isSunday(for date: Date) -> Bool { Calendar.current.component(.weekday, from: date) == 1 }
}


extension String {
    public func stringWithCapitalizedFirstCharacter() -> String {
        guard !isEmpty else { return self }

        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
}
