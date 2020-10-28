//
//  CalendarModel.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import Foundation

enum WeekDay: Int {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
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
}


extension String {
    public func stringWithCapitalizedFirstCharacter() -> String {
        guard !isEmpty else { return self }

        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
}
