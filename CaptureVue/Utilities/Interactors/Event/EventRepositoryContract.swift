//
//  EventRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

protocol EventRepositoryContract {
    func validateEvent(_ eventId: String) async -> Result<ValidateEvent, CaptureVueResponseRaw>
    func fetchEvent(_ eventId: String) async -> Result<Event, CaptureVueResponseRaw>
    func createEvent(_ createEventRequest: CreateEventRequest, _ eventImage: Data) async -> Result<CreateEventResponse, CaptureVueResponseRaw>
}
