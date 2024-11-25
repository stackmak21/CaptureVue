//
//  Event.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/11/24.
//

import Foundation

struct EventDto: Codable, Identifiable {
    var id: String
    var eventName: String
    var mainImage: String
    var eventDescription: String
    var expires: Int64
    var createdAt: Int64
    var dateStart: Int64
    var dateEnd: Int64
    var guests: Int
    var creator: Customer
    var storiesList: [StoryItem]
    var galleryList: [GalleryItem]

    enum CodingKeys: String, CodingKey {
        case id = "eventId"
        case eventName
        case mainImage
        case eventDescription
        case expires
        case createdAt
        case dateStart
        case dateEnd
        case guests
        case creator
        case storiesList
        case galleryList
    }
}

struct StoryItem: Codable, Identifiable{
    
    var id: String
    var url: String
    var previewUrl: String
    var type: MediaType
    var creator: Customer
    var isSeen: Bool = false
    
    
    enum CodingKeys: String, CodingKey{
        case id
        case url
        case previewUrl
        case type
        case creator
    }
}



enum MediaType: String, Codable {
    case photo = "PHOTO"
    case video = "VIDEO"
}

struct GalleryItem: Codable, Identifiable{
    var id: String
    var publicUrl: String
    var creatorId: String
    var createdAt: Int64
    var eventId: String
    var dataType: MediaType
    var previewUrl: String
    var customer: Customer
    
    enum CodingKeys: String, CodingKey{
        case id = "galleryId"
        case publicUrl
        case creatorId
        case createdAt
        case eventId
        case dataType
        case previewUrl
        case customer
    }
}

struct Customer: Codable, Identifiable{
    var id: String
    var firstName: String
    var lastName: String
    var createdAt: Int64
    var isVerified: Bool
    
    
    enum CodingKeys: String, CodingKey{
        case id
        case firstName = "firstname"
        case lastName = "lastname"
        case createdAt
        case isVerified
    }
}
