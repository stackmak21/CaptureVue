//
//  EventApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation


struct EventApi {
    
    private let client: NetworkClient
    
    init(client: NetworkClient) { self.client = client }
    
    func validateEvent(_ eventId: String) async -> Result<ValidateEventDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "/api/v1/event/validate",
            queryItems: ["eventId": eventId]
        )
    }
    
    func fetchEvent(_ eventId: String, _ token: String) async -> Result<EventDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "/api/v1/event",
            authToken: token,
            queryItems: ["eventId": eventId]
        )
    }
}
