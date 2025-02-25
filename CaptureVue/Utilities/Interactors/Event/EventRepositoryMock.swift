//
//  EventRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation


struct EventRepositoryMock: EventRepositoryContract{
    
    func validateEvent(_ eventId: String) async -> Result<ValidateEvent, CaptureVueError> {
        return.success(ValidateEvent(isValid: true, expiresAt: 1000004, startsAt: 100002, hasExpired: false))
    }
    
    func fetchEvent(_ eventId: String, _ token: String) async -> Result<Event, CaptureVueError> {
        return .success(DeveloperPreview.instance.event)
    }
    
    func createEvent(_ token: String, _ createEventRequest: CreateEventRequest, _ eventImage: Data) async -> Result<CreateEventResponse, CaptureVueError> {
        return .success(CreateEventResponse(msg: "message", paymentUrl: "payment url", success: true, eventId: "cp-1234"))
    }
    
}
