//
//  HomeInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation

class HomeInteractor {
    
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func fetchEvents(token: String) async throws -> [EventDto]? {
        do {
            let response: EventsDto? = try await dataService.downloadData(url: "\(urlPrefix)/allEvents", authToken: token)
            guard let events = response?.events else { return nil }
            return events
        } catch let error as CaptureVueError {
            throw error
        }
    }
}
