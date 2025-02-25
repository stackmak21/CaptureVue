//
//  EventRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

protocol EventRepositoryContract {
    func validateEvent(_ eventId: String) async -> Result<ValidateEvent, CaptureVueError>
    func fetchEvent(_ eventId: String, _ token: String) async -> Result<Event, CaptureVueError>
    func createEvent(_ token: String, _ createEventRequest: CreateEventRequest, _ eventImage: Data) async -> Result<CreateEventResponse, CaptureVueError>
}
