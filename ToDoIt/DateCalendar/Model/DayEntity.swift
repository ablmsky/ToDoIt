//
//  DayEntity.swift
//  ToDoIt
//
//  Created by Anton Ablamskiy on 29.06.2020.
//  Copyright © 2020 Anton Ablamskiy. All rights reserved.
//

import Foundation

class CalendarDay {
    let date: Date?
    
    var event: Any?
    let calendar = Calendar(identifier: .gregorian)
    
    init(date: Date?) {
        self.date = date
    }
    
    func getDay() -> Int? {
        guard let unwrapDate = date else {
            return nil
        }
        let component = calendar.dateComponents([.day, .month, .year], from: unwrapDate)
        return component.day
    }
    
    func getMonth() -> Int? {
        guard let unwrapDate = date else {
            return nil
        }
        let component = calendar.dateComponents([.day, .month, .year], from: unwrapDate)
        return component.month
    }
    
    func getYear() -> Int? {
        guard let unwrapDate = date else {
            return nil
        }
        let component = calendar.dateComponents([.day, .month, .year], from: unwrapDate)
        return component.year
    }
    
    func getWeekday() -> Int? {
        guard let unwrapDate = date else {
            return nil
        }
        return calendar.component(.weekday, from: unwrapDate)
    }
    
    func getDayLabel() -> String {
        guard let unwrapDay = getDay() else {
            return ""
        }
        return String(unwrapDay)
    }
    
    func getWeekdayDayLabel() -> String {
        guard let unwrapDay = getDay() else {
            return ""
        }
        return weekdaysNames() + ", " + String(unwrapDay)
    }
    
    func weekdaysNames() -> String {
        guard let unwrapWeekday = getWeekday() else {
            return ""
        }
        switch unwrapWeekday {
        case 2: return NSLocalizedString("MON", comment: "ПН")
        case 3: return NSLocalizedString("TUE", comment: "ВТ")
        case 4: return NSLocalizedString("WED", comment: "СР")
        case 5: return NSLocalizedString("THU", comment: "ЧТ")
        case 6: return NSLocalizedString("FRI", comment: "ПТ")
        case 7: return NSLocalizedString("SAT", comment: "СБ")
        case 1: return NSLocalizedString("SUN", comment: "ВС")
        default: return ""
        }
    }
}

