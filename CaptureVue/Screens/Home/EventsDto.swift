//
//  EventsDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation

struct Events {
    let events: [Event]
}

struct EventsDto: Codable {
    let events: [EventDto]?
    
    func toEvents() -> Events {
        return Events(
            events: self.events?.map{ $0.toEvent() } ?? []
        )
    }
}


