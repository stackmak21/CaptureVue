//
//  CreateEventUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/2/25.
//

import Foundation

struct CreateEventUseCase{
    
    private let repository: EventRepositoryContract
    
    init(client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil) {
        self.repository = eventRepositoryMock ?? EventRepository(client: client)
    }
    
    func invoke(_ token: String, _ createEventRequest: CreateEventRequest, _ eventImage: Data) async -> Result<CreateEventResponse, CaptureVueError> {
        return await repository.createEvent(token, createEventRequest, eventImage)
    }
}
