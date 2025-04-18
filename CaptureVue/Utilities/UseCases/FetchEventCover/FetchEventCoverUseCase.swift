//
//  FetchEventCoverUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/4/25.
//

import Foundation

struct FetchEventCoverUseCase{
    
    private let repository: EventRepositoryContract
    
    init(client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil) {
        self.repository = eventRepositoryMock ?? EventRepository(client: client)
    }
    
    func invoke(_ eventId: String) async -> Result<EventCover, CaptureVueResponseRaw> {
        return await repository.fetchEventCover(eventId)
    }
}
