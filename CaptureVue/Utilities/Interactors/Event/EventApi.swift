//
//  EventApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation


struct EventApi {
    
    private let client: NetworkClient
    
    init(client: NetworkClient) { self.client = client }
    
    func validateEvent(_ eventId: String) async -> Result<ValidateEventDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "api/v1/event/validate",
            queryItems: ["eventId": eventId]
        )
    }
    
    func fetchEvent(_ eventId: String, _ token: String) async -> Result<EventDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "api/v1/event",
            authToken: token,
            queryItems: ["eventId": eventId]
        )
    }
    
    func createEvent(_ token: String, _ createEventRequest: CreateEventRequest, _ eventImage: Data) async -> Result<CreateEventResponseDto, CaptureVueErrorDto> {
        var multipartRequest = MultipartRequest()
        if let requestBodyJson = try? JSONEncoder().encode(createEventRequest){
            multipartRequest.add(key: "createEventRequest", value: requestBodyJson)
        }else{
            return .failure(CaptureVueErrorDto(msg: nil, code: nil, reason: nil))
        }
        multipartRequest.add(key: "eventImage", fileName: "event_image.jpg", fileMimeType: "image/jpeg", fileData: eventImage)
        
        return await client.execute(
            url: "api/v1/event/create",
            authToken: token,
            httpMethod: .post,
            headers: ["Content-Type": multipartRequest.httpContentTypeHeaderValue],
            requestBody: multipartRequest.httpBody
            
        )
    }
}
