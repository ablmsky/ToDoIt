//
//  SMCalendarView.swift
//  SafeMail
//
//  Created by Anton Ablamskiy on 01.06.2020.
//  Copyright © 2020 NITS ZAO. All rights reserved.
//

import UIKit
//import ReactiveSwift

class SMCalendarView: UIStackView {
    var presenter: CalendarPresenter!
    var presentationType: CalendarStyle!
    var weekdaysStack: UIStackView?
    
    let dateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    convenience init(presenter: CalendarPresenter) {
        self.init()
        self.presenter = presenter
        self.presentationType = CalendarStyle.month
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = 20
        self.isUserInteractionEnabled = true
        
        let dayLabelStack = createWeekdaysLabels(data: weekdaysNames())
        weekdaysStack = dayLabelStack
        self.addArrangedSubview(dayLabelStack)
        self.addArrangedSubview(dateStack)
        createCalendar(data: presenter.createCalendar())
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(gesture:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(gesture:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
    }
    
    func createCalendar(data: [[CalendarDay]]) {
        dateStack.removeFromSuperview()
        _ = dateStack.subviews.map { sub in
            sub.removeFromSuperview()
        }
        for week in data {
            let weekStack = createWeekStack(data: week)
            dateStack.addArrangedSubview(weekStack)
            _ = weekStack.subviews.map { view in
                if presentationType != CalendarStyle.few {
                    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectDate(gesture:))))
                }
            }
        }
        self.addArrangedSubview(dateStack)
    }
    
    
    func createWeekStack(data: [CalendarDay]) -> UIStackView{
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillEqually
        createDatelabel(stack: stack, labels: data)
        return stack
    }
    
    func createDatelabel(stack: UIStackView,labels: [CalendarDay]) {
        for i in 0..<labels.count {
            let source = presentationType == CalendarStyle.few ? labels[i].getWeekdayDayLabel() : labels[i].getDayLabel()
            let view = TDIDateView(name: source,presentationType: presentationType, date: labels[i])
            if labels[i].date == presenter.getInitialDate() {
                view.showSelected()
                if presentationType != CalendarStyle.few {
                    view.showCurrent()
                }
            }
            stack.addArrangedSubview(view)
            if i > 4 {
                view.setHoliday()
            }
        }
    }
    
    private func weekdaysNames() -> [String] {
        let monday = NSLocalizedString("MON", comment: "ПН")
        let tuesday = NSLocalizedString("TUE", comment: "ВТ")
        let wednesday = NSLocalizedString("WED", comment: "СР")
        let thursday = NSLocalizedString("THU", comment: "ЧТ")
        let friday = NSLocalizedString("FRI", comment: "ПТ")
        let saturday = NSLocalizedString("SAT", comment: "СБ")
        let sunday = NSLocalizedString("SUN", comment: "ВС")
        return [monday,tuesday,wednesday,thursday,friday,saturday,sunday]
    }
    
    func createWeekdaysLabels(data: [String]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillEqually
        for i in 0..<data.count {
            let view = TDIDateView(name: data[i],presentationType: CalendarStyle.month, date: nil)
            stack.addArrangedSubview(view)
            if i > 4 {
                view.setHoliday()
            }
        }
        return stack
    }
    
    
    @objc func selectDate(gesture: UITapGestureRecognizer) {
        guard let date = gesture.view as? TDIDateView else {
            return
        }
        _ = dateStack.subviews.map { sub in
            if let subStack = sub as? UIStackView {
                setUnselect(stack: subStack)
            }
        }
        if date.name != nil && !date.name.isEmpty {
            date.showSelected()
            print(date.name)
        }
    }
    
    @objc func swipeAction(gesture: UISwipeGestureRecognizer) {
        _ = self.dateStack.subviews.map { sub in
            sub.removeFromSuperview()
        }
        switch gesture.direction {
        case .right:
            switch presentationType {
            case .month:
                presenter.date = Calendar.current.date(byAdding: .month, value: -1, to: presenter.date) ?? Date()
                createCalendar(data: presenter.createCalendar())
            case .single:
                let week = presenter.getAnotherWeek(monthGap: -1)
                createCalendar(data: [week])
            case .few:
                let week = presenter.threeDaysShowing(value: -1)
                createCalendar(data: [week])
            default: return
            }
        case .left:
            switch presentationType {
            case .month:
                presenter.date = Calendar.current.date(byAdding: .month, value: 1, to: presenter.date) ?? Date()
                createCalendar(data: presenter.createCalendar())
            case .single:
                let week = presenter.getAnotherWeek(monthGap: 1)
                createCalendar(data: [week])
            case .few:
                let week = presenter.threeDaysShowing(value: 1)
                createCalendar(data: [week])
            default: return
            }
        default: return
        }
        presenter.labelsDataSourceObserver.send(value: ())
    }
    
    
    func setUnselect(stack: UIStackView) {
        _ = stack.subviews.map { view in
            if let date = view as? TDIDateView {
                date.hideSelection()
            }
        }
    }
    
    
}



