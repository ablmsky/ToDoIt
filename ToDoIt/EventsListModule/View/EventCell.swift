//
//  EventCell.swift
//  ToDoIt
//
//  Created by Anton Ablamskiy on 25.06.2020.
//  Copyright © 2020 Anton Ablamskiy. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    static let identifier = "EventCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionField: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    init(name: String, date: String, description: String, status: Status) {
        super.init(style: .default, reuseIdentifier: EventCell.identifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionField)
        nameLabelConstraints()
        dateLabelConstraints()
        descriptionConstraints()
        
        setBackgroundColor(status: status)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor(status: Status) {
        let color: UIColor
        switch  status {
        case .completed: color = .green
        case .inProgress: color = .orange
        case .outOfTime: color = .red
        }
        contentView.backgroundColor = color
    }
    
    private func nameLabelConstraints() {
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.bounds.width - 150).isActive = true
    }
    
    private func dateLabelConstraints() {
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    private func descriptionConstraints() {
        descriptionField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        descriptionField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        descriptionField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        descriptionField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
