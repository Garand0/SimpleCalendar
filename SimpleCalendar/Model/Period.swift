//
//  Period.swift
//  SimpleCalendar
//
//  Created by Garando on 10/29/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import Foundation

public struct Period: Hashable, Comparable {
    /// Начало периода
    public let startDate: Date

    /// Конец периода
    public let endDate: Date

    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }

    public static func < (lhs: Period, rhs: Period) -> Bool {
        lhs.startDate < rhs.startDate && lhs.endDate < rhs.endDate
    }

    public func contains(date: Date?) -> Bool {
        guard let date = date else { return false }
        return date.isBetweeen(date: startDate, andDate: endDate)
    }
}

extension Date {
    public func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        date1.compare(self).rawValue * compare(date2).rawValue >= 0
    }
}
