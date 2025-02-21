//
//  ValidateEventUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct ValidateEventUseCase{
    
    private let repository: EventRepositoryContract
    
    init(client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil) {
        self.repository = eventRepositoryMock ?? EventRepository(client: client)
    }
    
    func invoke(_ eventId: String) async -> Result<ValidateEvent, CaptureVueError> {
        return await repository.validateEvent(eventId)
    }
}
