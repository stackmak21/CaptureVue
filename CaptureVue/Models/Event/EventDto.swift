//
//  Event.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/11/24.
//

import Foundation

struct EventDto: Codable, Identifiable {
    let id: String?
    let eventName: String?
    let mainImage: String?
    let eventDescription: String?
    let expires: Int64?
    let createdAt: Int64?
    let dateEnd: Int64?
    let guests: Int?
    let creator: CustomerDto?
    let storiesList: [StoryItemDto]?
    let galleryList: [GalleryItemDto]?

    enum CodingKeys: String, CodingKey {
        case id = "eventId"
        case eventName
        case mainImage
        case eventDescription
        case expires
        case createdAt
        case dateEnd
        case guests
        case creator
        case storiesList
        case galleryList
    }
    
    func toEvent() -> Event {
        return Event(
            id: self.id ?? "",
            eventName: self.eventName ?? "",
            mainImage: self.mainImage ?? "",
            eventDescription: self.eventDescription ?? "",
            expires: self.expires ?? 0,
            createdAt: self.createdAt ?? 0,
            dateEnd: self.dateEnd ?? 0,
            guests: self.guests ?? 0,
            creator: self.creator?.toCustomer() ?? Customer(),
            storiesList: self.storiesList?.map{ $0.toStoryItem() } ?? [],
            galleryList: self.galleryList?.map { $0.toGalleryItem() } ?? []
        )
    }
}







enum MediaType: String, Codable {
    case photo = "PHOTO"
    case video = "VIDEO"
}








