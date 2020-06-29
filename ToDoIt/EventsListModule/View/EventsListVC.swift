//
//  ViewController.swift
//  ToDoIt
//
//  Created by Anton Ablamskiy on 25.06.2020.
//  Copyright © 2020 Anton Ablamskiy. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController {
    var presenter: EventsListPresenter!
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let creationIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init() {
        self.init()
        presenter = EventsListPresenterImpl()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        
        view.addSubview(headerLabel)
        view.addSubview(creationIcon)
        view.addSubview(tableView)
        
        headerLabelConstraints()
        creationIconConstraints()
        tableConstraints()
    }
    
    private func headerLabelConstraints() {
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func creationIconConstraints() {
        creationIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        creationIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
    }
    
    private func tableConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
    }
}

extension EventsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfElements()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

