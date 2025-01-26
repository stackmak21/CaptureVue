//
//  HomeInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation

class CreateEventInteractor {
    
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func uploadPhoto(token: String, request: CreateEventRequest, imageData: Data?) async throws -> CreateEventResponse? {
        do {
            let response: CreateEventResponse? = try await dataService.uploadPhoto(url: "\(urlPrefix)/event/create", createEventRequest: request, imageData: imageData, authToken: token)
            guard let uploadResponse = response else { return nil }
            return uploadResponse
        } catch let error as CaptureVueError {
            throw error
        }
    }
}
