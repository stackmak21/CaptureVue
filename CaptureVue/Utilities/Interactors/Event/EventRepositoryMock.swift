//
//  EventRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation


struct EventRepositoryMock: EventRepositoryContract{
    
    func validateEvent(_ eventId: String) async -> Result<ValidateEvent, CaptureVueResponseRaw> {
        return.success(ValidateEvent(isValid: true, expiresAt: 1000004, startsAt: 100002, hasExpired: false))
    }
    
    func fetchEvent(_ eventId: String) async -> Result<Event, CaptureVueResponseRaw> {
        return .success(DeveloperPreview.instance.event)
    }
    
    func createEvent(_ createEventRequest: CreateEventRequest, _ eventImage: Data) async -> Result<CreateEventResponse, CaptureVueResponseRaw> {
        return .success(CreateEventResponse(msg: "message", paymentUrl: "payment url", success: true, eventId: "cp-1234"))
    }
    
    func fetchEventCover(_ eventId: String) async -> Result<EventCover, CaptureVueResponseRaw>{
        return .success(EventCover())
    }
    
}
