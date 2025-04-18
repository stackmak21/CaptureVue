//
//  EventCoverDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/4/25.
//

import Foundation

struct EventCoverDto: Codable, Identifiable {
    let id: String?
    let eventName: String?
    let mainImage: String?
    let qrCodeImage: String?
    let eventDescription: String?
    let createdAt: Int64?
    let dateStart: Int64?
    let dateEnd: Int64?
    let guestsCanViewGallery: Bool?
    let authorizeGuests: Bool?
    let isValid: Bool?
    let expiresAt: Int64?
    let startsAt: Int64?
    let hasExpired: Bool?
    

    enum CodingKeys: String, CodingKey {
        case id = "eventId"
        case eventName
        case mainImage
        case qrCodeImage
        case eventDescription
        case createdAt
        case dateEnd
        case dateStart
        case guestsCanViewGallery
        case authorizeGuests
        case isValid
        case hasExpired
        case expiresAt
        case startsAt
    }
    
    func toEventCover() -> EventCover {
        return EventCover(
            id: self.id ?? "",
            eventName: self.eventName ?? "",
            mainImage: self.mainImage ?? "",
            qrCodeImage: self.qrCodeImage ?? "",
            eventDescription: self.eventDescription ?? "",
            createdAt: self.createdAt ?? 0,
            dateStart: self.dateStart ?? 0,
            dateEnd: self.dateEnd ?? 0,
            guestsCanViewGallery: self.guestsCanViewGallery ?? false,
            authorizeGuests: self.authorizeGuests ?? false,
            isValid: self.isValid ?? false,
            expiresAt: self.expiresAt ?? 0,
            startsAt: self.startsAt ?? 0,
            hasExpired: self.hasExpired ?? false
        )
    }
}

struct EventCover{
    
    let id: String
    let eventName: String
    let mainImage: String
    let qrCodeImage: String
    let eventDescription: String
    let createdAt: Int64
    let dateStart: Int64
    let dateEnd: Int64
    let guestsCanViewGallery: Bool
    let authorizeGuests: Bool
    let isValid: Bool
    let expiresAt: Int64
    let startsAt: Int64
    let hasExpired: Bool
    
    init(
        id: String = "",
        eventName: String = "",
        mainImage: String = "",
        qrCodeImage: String = "",
        eventDescription: String = "",
        createdAt: Int64 = 0,
        dateStart: Int64 = 0,
        dateEnd: Int64 = 0,
        guestsCanViewGallery: Bool = false,
        authorizeGuests: Bool = false,
        isValid: Bool = false,
        expiresAt: Int64 = 0,
        startsAt: Int64 = 0,
        hasExpired: Bool = false
    ) {
        self.id = id
        self.eventName = eventName
        self.mainImage = mainImage
        self.qrCodeImage = qrCodeImage
        self.eventDescription = eventDescription
        self.createdAt = createdAt
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.guestsCanViewGallery = guestsCanViewGallery
        self.authorizeGuests = authorizeGuests
        self.isValid = isValid
        self.expiresAt = expiresAt
        self.startsAt = startsAt
        self.hasExpired = hasExpired
    }
}
