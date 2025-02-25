//
//  CreateEventRequest.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/1/25.
//

import Foundation


struct CreateEventRequest: Codable {
    let eventName: String?
    let eventDescription: String?
    let eventStartDate: Int?
    let eventEndDate: Int?
    let guests: Int?
    let authorizeGuests: Bool?
    let contentDurationMonths: Int?
    let guestsCanViewGallery: Bool?
    let guestsUploadPhoto: Bool?
    let guestsUploadVideo: Bool?
    let supportStories: Bool?
    
    enum CodingKeys: String, CodingKey {
        case eventName
        case eventDescription
        case eventStartDate
        case eventEndDate
        case guests
        case authorizeGuests
        case contentDurationMonths
        case guestsCanViewGallery
        case guestsUploadPhoto
        case guestsUploadVideo
        case supportStories
    }
}
