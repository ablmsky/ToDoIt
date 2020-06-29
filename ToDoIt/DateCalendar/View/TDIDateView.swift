//
//  TDIDateView.swift
//  ToDoIt
//
//  Created by Anton Ablamskiy on 29.06.2020.
//  Copyright © 2020 Anton Ablamskiy. All rights reserved.
//

import UIKit

enum CalendarStyle {
    case events
    case single
    case few
    case month
}

class TDIDateView: UIView {
    var selected: Bool?
    var holiday: Bool?
    var name: String!
    var presentationType: CalendarStyle!
    var date: CalendarDay?
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()
    
    private let currentCircle: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-currentCircle"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let selectedCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.isHidden = true
        view.layer.cornerRadius = 17
        return view
    }()
    
    private let eventIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 2.7
        view.isHidden = true
        return view
    }()
    
    convenience init(name: String, presentationType: CalendarStyle,date: CalendarDay?) {
        self.init()
        self.name = name
        self.date = date
        self.presentationType = presentationType
        let width = self.widthAnchor.constraint(equalToConstant: 30)
        width.priority = UILayoutPriority(700)
        width.isActive = true
        let height = self.heightAnchor.constraint(equalToConstant: 34)
        height.priority = UILayoutPriority(700)
        height.isActive = true
        self.addSubview(selectedCircle)
        self.addSubview(label)
        self.addSubview(eventIndicator)
        self.addSubview(currentCircle)
        
        label.text = name
        
        selectedCircleConstraints()
        labelConstriants()
        eventIndicatorConstraints()
        currentCircleConstraints()
    }
    
    public func showEventIndicator() {
        self.eventIndicator.isHidden = false
    }
    
    public func setHoliday() {
        label.textColor = .gray
        self.holiday = true
    }
    
    public func showSelected() {
        self.selected = true
        self.selectedCircle.isHidden = false
        self.label.textColor = .white
        self.eventIndicator.backgroundColor = .white
    }
    
    public func hideSelection() {
        guard let hide = selected, hide else {
            return
        }
        self.selectedCircle.isHidden = hide
        self.label.textColor = (self.holiday ?? false) ? .gray : .darkGray
        self.eventIndicator.backgroundColor = .blue
    }
    
    public func showCurrent() {
        self.currentCircle.isHidden = false
    }
    
    private func labelConstriants() {
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func selectedCircleConstraints() {
        selectedCircle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        selectedCircle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let width = selectedCircle.widthAnchor.constraint(equalToConstant: 34)
        if presentationType == CalendarStyle.few {
            width.constant = 68
        }
        width.priority = UILayoutPriority(700)
        width.isActive = true
        let height = selectedCircle.heightAnchor.constraint(equalToConstant: 34)
        height.priority = UILayoutPriority(700)
        height.isActive = true
    }
    
    private func eventIndicatorConstraints() {
        eventIndicator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: -3).isActive = true
        let height = eventIndicator.heightAnchor.constraint(equalToConstant: 6)
        height.priority = UILayoutPriority(700)
        height.isActive = true
        let width = eventIndicator.widthAnchor.constraint(equalToConstant: 6)
        width.priority = UILayoutPriority(700)
        width.isActive = true
        eventIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func currentCircleConstraints() {
        currentCircle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        currentCircle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}

