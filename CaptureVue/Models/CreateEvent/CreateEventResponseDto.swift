//
//  CreateEventResponseDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/1/25.
//

import Foundation

struct CreateEventResponseDto: Codable {
    let msg: String?
    let paymentUrl: String?
    let success: Bool?
    let eventId: String?
    
    func toCreateEventResponse() -> CreateEventResponse {
        return CreateEventResponse(
            msg: self.msg ?? "",
            paymentUrl: self.paymentUrl ?? "",
            success: self.success ?? false,
            eventId: self.eventId ?? ""
        )
    }
}
