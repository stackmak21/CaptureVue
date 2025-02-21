//
//  CreateEventResponse.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/1/25.
//

import Foundation

struct CreateEventResponse: Codable {
    let msg: String?
    let paymentUrl: String?
    let success: Bool?
    let eventId: String?
}
