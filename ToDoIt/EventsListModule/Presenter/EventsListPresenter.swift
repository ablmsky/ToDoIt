//
//  EventsListPresenter.swift
//  ToDoIt
//
//  Created by Anton Ablamskiy on 25.06.2020.
//  Copyright © 2020 Anton Ablamskiy. All rights reserved.
//

import Foundation

enum Status {
    case completed
    case inProgress
    case outOfTime
}

protocol EventsListPresenter {
    func numberOfElements() -> Int
    func getEventData(indexPath: IndexPath) -> EventEntity
    func getEventStatus(indexPath: IndexPath) -> Status
}

class EventsListPresenterImpl: EventsListPresenter {
    
    func numberOfElements() -> Int {
        //пока заглушка
        return 5
    }
    
    func getEventData(indexPath: IndexPath) -> EventEntity {
        //аналогично
        return EventEntity(name: "Name", description: "Description", timeIntervar: [])
    }
    
    func getEventStatus(indexPath: IndexPath) -> Status {
        //аналогично х2
        return Status.inProgress
    }
    
}
