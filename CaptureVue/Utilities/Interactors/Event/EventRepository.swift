//
//  EventRepository.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct EventRepository: EventRepositoryContract {

    private let eventApi: EventApi
    
    init(client: NetworkClient) { self.eventApi = EventApi(client: client) }
    
    func validateEvent(_ eventId: String) async -> Result<ValidateEvent, CaptureVueError> {
        return await eventApi.validateEvent(eventId)
            .map({ $0.toValidateEvent() })
            .mapError({ $0.toCaptureVueError() })
    }
    
    func fetchEvent(_ eventId: String, _ token: String) async -> Result<Event, CaptureVueError> {
        return await eventApi.fetchEvent(eventId, token)
            .map({ $0.toEvent() })
            .mapError({ $0.toCaptureVueError() })
    }
    
}
