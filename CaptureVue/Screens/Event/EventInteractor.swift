//
//  EventInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import Foundation
//
//protocol EventInteractorProtocol {
//    var dataService: NetworkClient { get }
//    func fetchEventDetails(eventId: String, token: String) async throws -> Event
//    func fetchDirectUploadUrl(eventId: String, section: AssetSectionType, token: String) async throws -> String
//}
//
//
//class EventInteractor: EventInteractorProtocol{
//    
//    let dataService: NetworkClient
//    
//    init(dataService: NetworkClient) {
//        self.dataService = dataService
//    }
//    
//
//    
//    func fetchEventDetails(eventId: String, token: String) async throws -> Event {
//        do {
//            let response: EventDto? = try await dataService.downloadData(url: "\(urlPrefix)/event?eventId=\(eventId)", authToken: token)
//            if let eventDto = response {
//                return eventDto.toEvent()
//            }
//            throw CaptureVueErrorDto.decodeResponseError
//        } catch let error as CaptureVueErrorDto {
//            throw error
//        }
//    }
//    
//    func fetchDirectUploadUrl(eventId: String, section: AssetSectionType, token: String) async throws -> String {
//        do {
//            let response: DirectUploadUrl? = try await dataService.downloadData(url: "\(urlPrefix)/gallery/directUploadUrl?eventId=\(eventId)&section=\(section.rawValue)", authToken: token)
//            if let url = response?.url {
//                return url
//            }
//            throw CaptureVueErrorDto.decodeResponseError
//        } catch let error as CaptureVueErrorDto {
//            throw error
//        }
//    }
//   
//}

//class EventInteractorMock: EventInteractorProtocol {
//    let dataService: NetworkClient
//    
//    init(dataService: NetworkClient = DataServiceImpl()) {
//        self.dataService = dataService
//    }
//    
//    
//    func fetchEventDetails(eventId: String, token: String) async throws -> Event {
//        return DeveloperPreview.instance.event
//    }
//    
//    func fetchDirectUploadUrl(eventId: String, section: AssetSectionType, token: String) async throws -> String {
//        return ""
//    }
//    
//    
//}
