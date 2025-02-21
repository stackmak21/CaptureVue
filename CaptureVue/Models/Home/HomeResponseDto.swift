//
//  HomeResponseDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation


struct HomeResponseDto: Codable {
    let customer: CustomerDto?
    let hostEvents: [EventDto]?
    let participatingEvents: [EventDto]?
    
    enum CodingKeys: String, CodingKey{
        case customer
        case hostEvents
        case participatingEvents
    }
    
    func toHomeResponse() -> HomeResponse {
        HomeResponse(
            customer: self.customer?.toCustomer() ?? Customer() ,
            hostEvents: self.hostEvents?.map({$0.toEvent()}) ?? [] ,
            participatingEvents: self.participatingEvents?.map({$0.toEvent()}) ?? []
        )
    }
}



