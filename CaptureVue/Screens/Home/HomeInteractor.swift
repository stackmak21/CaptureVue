//
//  HomeInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation
//
//class HomeInteractor {
//    
//    let dataService: NetworkClient
//    
//    init(dataService: NetworkClient) {
//        self.dataService = dataService
//    }
//    
//    func fetchEvents(token: String) async throws -> [Event] {
//        do {
//            let response: EventsDto? = try await dataService.downloadData(url: "\(urlPrefix)/allEvents", authToken: token)
//            if let eventsDto = response?.events{
//                return eventsDto.map{ $0.toEvent() }
//            }
//            throw CaptureVueErrorDto.decodeResponseError
//        } catch let error as CaptureVueErrorDto {
//            throw error
//        }
//    }
//}
