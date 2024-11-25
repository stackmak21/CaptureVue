//
//  EventHomeInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import Foundation

class EventHomeInteractor{
    
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    

    
    func fetchEventDetails(eventId: String) async throws -> EventDto? {
        do {
            let response: EventDto? = try await dataService.downloadData(url: "\(urlPrefix)event?eventId=\(eventId)")
                return response
        } catch let error as CaptureVueError {
            throw error
        }
    }
   
}
