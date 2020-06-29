//
//  CalendarBaseViewController.swift
//  SafeMail
//
//  Created by Anton Ablamskiy on 20.04.2020.
//  Copyright © 2020 NITS ZAO. All rights reserved.
//

import UIKit

class CalendarBaseViewController: UIViewController {
    private var presenter: CalendarPresenter!
    private var currentShowingMonth: Int!
    private var heightTableConstraint: NSLayoutConstraint?
    private var heightViewConstraint: NSLayoutConstraint?
    private var eventsTopAnchor: NSLayoutConstraint?
    
    var calendarView: SMCalendarView!
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 25)
        label.alpha = 0.5
        return label
    }()
    
    let filterButton: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-filter-blue"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let addButton: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ic-add-calendar-event"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    
    func oneDayPresentationStyle() {
        let currentWeek = presenter.oneDayDataSource()
        calendarView.createCalendar(data: [currentWeek])
    }
    
    private func createLine() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.alpha = 0.3
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CalendarPresenterImpl()
        calendarView = SMCalendarView(presenter: presenter)
        self.currentShowingMonth = presenter.getCurrentMonthNumber()
        view.addSubview(headerView)
        view.addSubview(calendarView)
        
        let line = createLine()
        headerView.addSubview(line)
        headerView.addSubview(monthLabel)
        headerView.addSubview(yearLabel)
        headerView.addSubview(addButton)
        headerView.addSubview(filterButton)
        
        monthLabel.text = presenter.getCurrentMonthName()
        yearLabel.text = presenter.getCurrentYear()
        
        headerConstraints()
        baseStackConstraints()
        monthLabelConstraints()
        yearLabelConstraints()
        addButtonConstraints()
        filterButtonConstraints()
        lineConstraints(view: line)
        
        presenter.labelsDataSourceSignal.observeValues { _ in
            self.monthLabel.text = self.presenter.getCurrentMonthName()
            self.yearLabel.text = self.presenter.getCurrentYear()
        }
    }
    
    
    private func lineConstraints(view: UIView) {
        view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
    }
    
    private func headerConstraints() {
        headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func baseStackConstraints() {
        calendarView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        let trailing = calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        trailing.priority = UILayoutPriority(750)
        trailing.isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
    }
    
    private func monthLabelConstraints() {
        monthLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        monthLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    }
    
    private func yearLabelConstraints() {
        yearLabel.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: 5).isActive = true
        yearLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    }
    
    private func addButtonConstraints() {
        addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        addButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    }
    
    private func filterButtonConstraints() {
        filterButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -20).isActive = true
        filterButton.heightAnchor.constraint(equalTo: addButton.heightAnchor, constant: 0).isActive = true
        filterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    }
    
}
    
}
