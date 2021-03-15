//
//  CalendarModelFactory.swift
//  Calendar
//
//  Created by Maksim Vakula on 7/18/20.
//  Copyright © 2020 Maksim Vakula. All rights reserved.
//

import Foundation

final class CalendarModelFactory {
    static func make(startDate: Date, endDate: Date) -> [CalendarModel] {
        let numberOfMonths = startDate.monthsBetweenDates(to: endDate)
        return (.zero ..< numberOfMonths).map {
            let dates = startDate.dateByAddingMonths($0).getMonth()
            return CalendarModel(startWeekDay: dates.first!.weekDay, dates: dates)
        }
    }
}


extension Date {
    /// День недели
    var weekDay: WeekDay {
        let weekday = Calendar.current.component(.weekday, from: self)
        return WeekDay(rawValue: weekday)!
    }
    
    /// Дата со временем начала дня
    public var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Начало месяца
    public var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: startOfDay))!
    }
    
    /// Конец месяца
    public var endOfMonth: Date? {
        let components = DateComponents(month: 1, day: -1)
        return Calendar.current.date(byAdding: components, to: startOfMonth)
    }
    /// Получаем массив из дат всех дней месяца
    public func getMonth() -> [Date] {
        let future = startOfMonth.dateByAddingMonths(1)
        var month: [Date] = []

        var date = startOfMonth
        while date.compare(future) != .orderedSame {
            month.append(date)
            date = date.dateByAddingDays(1)
        }

        return month
    }
    
    /// Кол-во дней между двумя датами
    public func daysBetweenDates(to date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: date)
        return components.day ?? .zero
    }
    
    /// Кол-во месяцев между двумя датами
    public func monthsBetweenDates(to date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self, to: date)
        return components.month ?? .zero
    }
    
    /// Получаем дату — текущая +/- дни
    public func dateByAddingDays(_ days: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return (calendar as NSCalendar).date(
            byAdding: .day,
            value: days,
            to: self,
            options: []
        )!
    }
    
    /// Получаем дату — текущая +/- месяцы
    public func dateByAddingMonths(_ months: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return (calendar as NSCalendar).date(
            byAdding: .month,
            value: months,
            to: self,
            options: []
        )!
    }

    public func isSameWeek(with date: Date) -> Bool {
        let selfWeek = Calendar.current.component(.weekOfMonth, from: self)
        let dateWeek = Calendar.current.component(.weekOfMonth, from: date)
        return selfWeek == dateWeek
    }
}
