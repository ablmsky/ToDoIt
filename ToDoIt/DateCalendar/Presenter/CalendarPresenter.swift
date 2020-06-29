//
//  CalendarPresenter.swift
//  ToDoIt
//
//  Created by Anton Ablamskiy on 29.06.2020.
//  Copyright © 2020 Anton Ablamskiy. All rights reserved.
//

import Foundation
//import ReactiveSwift

protocol CalendarPresenter {
    var date: Date { get set }
    func getCurrentMonthName() -> String
    func createCalendar() -> [[CalendarDay]]
    func getCurrentDayNumber() -> Int
    func getCurrentYear() -> String
    func getCurrentMonthNumber() -> Int
    func oneDayDataSource() -> [CalendarDay]
    func getAnotherWeek(monthGap: Int) -> [CalendarDay]
    func threeDaysShowing(value: Int) -> [CalendarDay]
    func getInitialDate() -> Date
    
//    var labelsDataSourceSignal: Signal<Void,NoError> { get }
//    var labelsDataSourceObserver: Signal<Void,NoError>.Observer { get }
}

class CalendarPresenterImpl: CalendarPresenter {
    private let calendar = Calendar(identifier: .gregorian)
    var date = Date()
    var currentWeek: [CalendarDay]?
    var weekIndex: Int?
    var currentCalendar: [[CalendarDay]]!
    var threeDayCurrent: [CalendarDay]?
    var adaptiveShowingDate = Date() //дата для обновления лейблов (название месяца, etc) в зависимости от текущего отображения
    var initialShowingDate: Date!
//    var labelsDataSourceSignal: Signal<Void,NoError>
//    var labelsDataSourceObserver: Signal<Void,NoError>.Observer
    
    init() {
//        (labelsDataSourceSignal,labelsDataSourceObserver) = Signal<Void, NoError>.pipe()
        self.currentCalendar = createCalendar()
        initialShowingDate = date
    }
    
    func getInitialDate() -> Date {
        return initialShowingDate
    }
    
    func getFirstWeekDayOfMonth() -> Int {
        return calendar.component(.weekday, from: calendar.startOfMonth(date))
    }
    
    func getNumberOfDaysInMonth() -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func getCurrentMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: adaptiveShowingDate).capitalizingFirstLetter()
    }
    
    func getCurrentYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: date)
    }
    
    func getCurrentMonthNumber() -> Int {
        return calendar.component(.month, from: calendar.startOfMonth(date))
    }
    
    func getCurrentDayNumber() -> Int {
        let component = calendar.dateComponents([.day, .month, .year], from: date)
        return component.day ?? 1
    }
    
    func getCurrentDayWeekday() -> Int {
        let component = calendar.dateComponents([.day, .month, .year], from: date)
        //американский формат, неделя начинается с воскр. - значение 1, суббота - значение 7
        return component.weekday ?? 2
    }
    
    func daysInAnotherMonth(week: [CalendarDay]) -> [CalendarDay] {
        var day = date
        var result = week
        if result[0].date == nil {
            let anotherMonth = Calendar.current.date(byAdding: .month, value: -1, to: date) ?? Date()
            let range = calendar.range(of: .day, in: .month, for: anotherMonth)!
            var dayComponent = DateComponents()
            dayComponent.day = range.count - getCurrentDayNumber()
            day = calendar.date(byAdding: dayComponent, to: anotherMonth) ?? Date()
            result = result.reversed()
            for i in 0..<result.count {
                if result[i].date == nil {
                    result[i] = CalendarDay(date: day)
                    dayComponent.day = -1
                    day = calendar.date(byAdding: dayComponent, to: day) ?? Date()
                }
            }
            result = result.reversed()
        } else if result[result.count-1].date == nil {
            let anotherMonth = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? Date()
            var dayComponent = DateComponents()
            dayComponent.day = -getCurrentDayNumber() + 1
            day = calendar.date(byAdding: dayComponent, to: anotherMonth) ?? Date()
            for i in 0..<result.count {
                if result[i].date == nil {
                    result[i] = CalendarDay(date: day)
                    dayComponent.day = 1
                    day = calendar.date(byAdding: dayComponent, to: day) ?? Date()
                }
            }
        }
        return result
    }
    
    func getAnotherWeek(monthGap: Int) -> [CalendarDay] {
        let unwrapWeek = currentWeek == nil ? oneDayDataSource() : currentWeek
        switch monthGap {
        case 0: return daysInAnotherMonth(week: unwrapWeek!)
        case 1:
            if weekIndex != nil {
                weekIndex! += 1
                if currentCalendar.count < weekIndex! + 1 {
                     return switchToAnotherMonth(value: monthGap)
                } else {
                    return daysInAnotherMonth(week: currentCalendar[weekIndex!])
                }
            }
        case -1:
            if weekIndex != nil {
                weekIndex! -= 1
                if weekIndex! < 0 {
                    return switchToAnotherMonth(value: monthGap)
                } else {
                    return daysInAnotherMonth(week: currentCalendar[weekIndex!])
                }
            }
        default: return []
        }
        
        return []
      
    }
    
    func switchToAnotherMonth(value: Int) -> [CalendarDay]{
        date = Calendar.current.date(byAdding: .month, value: value, to: date) ?? Date()
        currentCalendar = createCalendar()
        switch value {
        case 1:
            if getFirstWeekDayOfMonth() != 2 {
                weekIndex = 1
                return currentCalendar[weekIndex!]
            }
            weekIndex = 0
            return currentCalendar[weekIndex!]
        case -1:
            if currentCalendar[currentCalendar.count-1].contains(where: { element in
                element.date == nil
            }) {
                weekIndex = currentCalendar.count-2
                return currentCalendar[weekIndex!]
            }
            weekIndex = currentCalendar.count-1
            return currentCalendar[weekIndex!]
        default: return []
        }
        
    }

    func oneDayDataSource() -> [CalendarDay] {
        let currentDay = getCurrentDayNumber()
        for i in 0..<currentCalendar.count {
            if currentCalendar[i].contains(where: { day in
                day.getDay() ?? 1 == currentDay
            }) {
                self.currentWeek = currentCalendar[i]
                self.weekIndex = i
                return currentCalendar[i]
            }
        }
        return []
    }

    func createCalendar() -> [[CalendarDay]] {
        let startDay = getFirstWeekDayOfMonth() == 1 ? 8 : getFirstWeekDayOfMonth()
        var dayComponent = DateComponents()
        dayComponent.day = -getCurrentDayNumber() + 1
        var loopDate = calendar.date(byAdding: dayComponent, to: date) ?? Date()
        var finishFilling = false
        var result = [[CalendarDay]]()
        while !finishFilling {
            var arr = [CalendarDay]()
            for i in 1..<8 {
                let loopDay = calendar.dateComponents([.day, .month, .year], from: loopDate).day
                if i < startDay-1 && loopDay == 1 {
                    let day = CalendarDay(date: nil)
                    arr.append(day)
                } else {
                    let day = CalendarDay(date: loopDate)
                    arr.append(day)
                    if day.getDay() == getNumberOfDaysInMonth() {
                        finishFilling = true
                        break
                    }
                    var dayComponent = DateComponents()
                    dayComponent.day = 1
                    loopDate = calendar.date(byAdding: dayComponent, to: loopDate) ?? Date()
                }
            }
            if !arr.isEmpty {
                while arr.count < 7 {
                    let day = CalendarDay(date: nil)
                    arr.append(day)
                }
                result.append(arr)
            }
            self.adaptiveShowingDate = date
        }
        return result
    }
    
    func threeDaysShowing(value: Int) -> [CalendarDay] {
        var array = [CalendarDay]()
        switch value {
        case 0:
            for i in 0..<3 {
                var dayComponent = DateComponents()
                dayComponent.day = i
                let day = calendar.date(byAdding: dayComponent, to: date) ?? Date()
                array.append(CalendarDay(date: day))
            }
        case 1:
            if threeDayCurrent != nil {
                let dayToImplement = threeDayCurrent![0].date ?? Date()
                for i in 0..<3 {
                    var dayComponent = DateComponents()
                    dayComponent.day = 3+i
                    let day = calendar.date(byAdding: dayComponent, to: dayToImplement) ?? Date()
                    array.append(CalendarDay(date: day))
                }
            }
        case -1:
            if threeDayCurrent != nil {
                let dayToImplement = threeDayCurrent![0].date ?? Date()
                for i in 0..<3 {
                    var dayComponent = DateComponents()
                    dayComponent.day = -3+i
                    let day = calendar.date(byAdding: dayComponent, to: dayToImplement) ?? Date()
                    array.append(CalendarDay(date: day))
                }
            }
        default: break
        }
        threeDayCurrent = array
        if let unwrapDate = array[1].date {
            self.adaptiveShowingDate = unwrapDate
        }
        return array
    }

}

extension Calendar {
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

