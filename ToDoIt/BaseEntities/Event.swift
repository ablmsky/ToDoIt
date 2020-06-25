//
//  Event.swift
//  ToDoIt
//
//  Created by Anton Ablamskiy on 25.06.2020.
//  Copyright © 2020 Anton Ablamskiy. All rights reserved.
//

import Foundation

class EventEntity {
    private let name: String
    private let description: String
    private let timeIntervar: [Date]
    
    init(name: String?, description: String?, timeIntervar: [Date]) {
        self.name = name ?? NSLocalizedString("Unnamed", comment: "Без названия")
        self.description = description ?? ""
        self.timeIntervar = timeIntervar
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getDescription() -> String {
        return self.description
    }
    
    public func getStartDate() -> Date {
        return timeIntervar[0]
    }
    
    public func getFinishDate() -> Date {
        return timeIntervar[1]
    }
}
