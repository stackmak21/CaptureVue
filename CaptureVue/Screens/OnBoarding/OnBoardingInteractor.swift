//
//  OnBoardingInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/10/24.
//

import Foundation



class OnBoardingInteractor{
    
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    

    
    func validateEvent(eventId: String, token: String) async throws -> ValidateEventDto? {
        do {
            let response: ValidateEventDto? = try await dataService.downloadData(url: "\(urlPrefix)/event/validate?eventId=\(eventId)", authToken: token)
                return response
        } catch let error as CaptureVueError {
            throw error
        } 
    }
    
    func fetchEvent(eventId: String, token: String) async throws -> EventDto? {
        do {
            let response: EventDto? = try await dataService.downloadData(url: "\(urlPrefix)/event?eventId=\(eventId)", authToken: token)
                return response
        } catch let error as CaptureVueError {
            throw error
        }
    }
   
}
