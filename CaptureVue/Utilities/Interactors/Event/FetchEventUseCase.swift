//
//  FetchEventUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct FetchEventUseCase{
    
    private let repository: EventRepositoryContract
    
    init(repository: EventRepositoryContract) { self.repository = repository }
    
    func invoke(_ eventId: String, _ token: String) async -> Result<Event, CaptureVueError> {
        return await repository.fetchEvent(eventId, token)
    }
}
