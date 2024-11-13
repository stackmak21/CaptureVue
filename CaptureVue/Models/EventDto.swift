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
    var storiesList: [StoryDataDto]
    var galleryList: [GalleryDataDto]

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
        case storiesList
        case galleryList
    }
}

struct StoryDataDto: Codable, Identifiable {
    var id: String
    var url: String
    var previewUrl: String
    var type: StoryType
}

enum StoryType: String, Codable {
    case photo = "PHOTO"
    case video = "VIDEO"
}

struct GalleryDataDto: Codable, Identifiable{
    var id: String
    var publicUrl: String
    var creatorId: String
    var createdAt: Int64
    var eventId: String
    var dataType: StoryType
    var previewUrl: String
    
    enum CodingKeys: String, CodingKey{
        case id = "storyId"
        case publicUrl
        case creatorId
        case createdAt
        case eventId
        case dataType
        case previewUrl
    }
}
