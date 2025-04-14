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
    
    func validateEvent(_ eventId: String) async -> Result<ValidateEvent, CaptureVueResponseRaw> {
        return await eventApi.validateEvent(eventId)
            .map({ $0.toValidateEvent() })
            .mapError({ $0 })
    }
    
    func fetchEvent(_ eventId: String) async -> Result<Event, CaptureVueResponseRaw> {
        return await eventApi.fetchEvent(eventId)
            .map({ $0.toEvent() })
            .mapError({ $0 })
    }
    
    func createEvent(_ createEventRequest: CreateEventRequest, _ eventImage: Data) async -> Result<CreateEventResponse, CaptureVueResponseRaw> {
        return await eventApi.createEvent(createEventRequest, eventImage)
            .map({ $0.toCreateEventResponse() })
            .mapError({ $0 })
    }
    
}
