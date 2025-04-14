//
//  FetchEventUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct FetchEventUseCase{
    
    private let repository: EventRepositoryContract
    
    init(client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil) {
        self.repository = eventRepositoryMock ?? EventRepository(client: client)
    }
    
    func invoke(_ eventId: String) async -> Result<Event, CaptureVueResponseRaw> {
        return await repository.fetchEvent(eventId)
    }
}
