//
//  Date+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit
import Foundation

// MARK: - General
extension Date {
    static let currentCalendar = Calendar(identifier: .gregorian)
    static let currentTimeZone = TimeZone.ReferenceType.local
    static let jstTimeZone: TimeZone = TimeZone(abbreviation: "JST") ?? Date.currentTimeZone
    
    init(year: Int, month: Int, day: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.year = year
        dc.month = month
        dc.day = day
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }
    
    init(hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.hour = hour
        dc.minute = minute
        dc.second = second
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }
    
    var currentAge: Int? {
        let ageComponents = Date.currentCalendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year
    }

    var yesterday: Date? {
        return Date.currentCalendar.date(byAdding: .day, value: -1, to: self)
    }
    var tomorrow: Date? {
        return Date.currentCalendar.date(byAdding: .day, value: 1, to: self)
    }
    
    var weekday: Int {
        return Date.currentCalendar.component(.weekday, from: self)
    }
    
    var firstDayOfTheMonth: Date? {
        let calendar = Date.currentCalendar
        return calendar.date(from: calendar.dateComponents([.year,.month], from: self))
    }
    
    var yearMonthDayNonOptional: (year: Int, month: Int, day: Int) {
        let comp = components()
        return (year: comp.year ?? -1, month: comp.month ?? -1, day: comp.day ?? -1)
    }
    
    var hourMinuteSecondNonOptional: (hour: Int, minute: Int, second: Int) {
        let comp = components()
        return (hour: comp.hour ?? -1, minute: comp.minute ?? -1, second: comp.second ?? -1)
    }
    
    func isToday(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInToday(self)
    }
    
    func isYesterday(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInYesterday(self)
    }
    
    func isTomorrow(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    func isWeekend(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInWeekend(self)
    }
    
    func isSamedayWith(date: Date, calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    func isSameDayMonthYearWith(date: Date, calendar: Calendar = Date.currentCalendar) -> Bool {
        let selfComp = components(calendar: calendar, timeZone: Date.currentTimeZone)
        let dateComp = date.components(calendar: calendar, timeZone: Date.currentTimeZone)
        return selfComp.year == dateComp.year && selfComp.month == dateComp.month && selfComp.day == dateComp.day
    }
    
    func components(calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents {
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            era: calendar.component(.era, from: self),
                                            year: calendar.component(.year, from: self),
                                            month: calendar.component(.month, from: self),
                                            day: calendar.component(.day, from: self),
                                            hour: calendar.component(.hour, from: self),
                                            minute: calendar.component(.minute, from: self),
                                            second: calendar.component(.second, from: self),
                                            nanosecond: calendar.component(.nanosecond, from: self),
                                            weekday: calendar.component(.weekday, from: self),
                                            weekdayOrdinal: calendar.component(.weekdayOrdinal, from: self),
                                            quarter: calendar.component(.quarter, from: self),
                                            weekOfMonth: calendar.component(.weekOfMonth, from: self),
                                            weekOfYear: calendar.component(.weekOfYear, from: self),
                                            yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: self))
        return dateComponents
    }

    static func startOfMonth(date: Date, calendar: Calendar = Date.currentCalendar) -> Date? {
        let calendar = Date.currentCalendar
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: date)))
    }
    
    static func getComponentFrom(string: String, format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents? {
        if let date = getDateBy(string: string, format: format, calendar: calendar, timeZone: timeZone) {
            return date.components(calendar: calendar, timeZone: timeZone)
        }
        return nil
    }
    
    static func endOfMonth(date: Date, calendar: Calendar = Date.currentCalendar) -> Date? {
        if let startOfMonth = startOfMonth(date: date, calendar: calendar) {
            return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        }
        return nil
    }
    
    static func dayEndOfMonth(date: Date, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Int {
        if let startOfMonth = startOfMonth(date: date, calendar: calendar) {
            if let day = (calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)?.components(calendar: calendar, timeZone: timeZone).day) {
                return day
            }
        }
        return -1
    }
    
    static func getDateBy(string: String, format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.date(from: string)
    }

    static func dateAt(timeInterval: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        return date.components(calendar: calendar, timeZone: timeZone)
    }
    
    static func getHourMinuteSecondFrom(secondValue: Int) -> (hour: Int, minute: Int, second: Int) {
        return (secondValue / 3600, (secondValue % 3600) / 60, (secondValue % 3600) % 60)
    }
    
    public static func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
  
    func add(day: Int? = nil, month: Int? = nil, year: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, calendar: Calendar = Date.currentCalendar) -> Date? {
        var dateComponent = DateComponents()
        if let year = year { dateComponent.year = year }
        if let month = month { dateComponent.month = month }
        if let day = day { dateComponent.day = day }
        if let hour = hour { dateComponent.hour = hour }
        if let minute = minute { dateComponent.minute = minute }
        if let second = second { dateComponent.second = second }
        return calendar.date(byAdding: dateComponent, to: self)
    }
    
    func stringBy(format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func years(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func months(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func weeks(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    func days(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func seconds(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func set(year: Int, month: Int, day: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        return self.set(year: year, calendar: calendar, timeZone: timeZone)?
            .set(month: month, calendar: calendar, timeZone: timeZone)?
            .set(day: day, calendar: calendar, timeZone: timeZone)
    }
    
    func set(hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        return self.set(hour: hour, calendar: calendar, timeZone: timeZone)?
            .set(minute: minute, calendar: calendar, timeZone: timeZone)?
            .set(second: second, calendar: calendar, timeZone: timeZone)
    }
    
    func set(year: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.year = year
        return calendar.date(from: components)
    }
    
    func set(month: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.month = month
        return calendar.date(from: components)
    }
    
    func set(day: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.day = day
        return calendar.date(from: components)
    }
    
    func set(hour: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.hour = hour
        return calendar.date(from: components)
    }
    
    func set(minute: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.minute = minute
        return calendar.date(from: components)
    }
    
    func set(second: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.second = second
        return calendar.date(from: components)
    }
    
    //convert to string
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
