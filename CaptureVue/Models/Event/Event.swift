//
//  Event.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct Event{
    
    let id: String
    let eventName: String
    let mainImage: String
    let qrCodeImage: String
    let eventDescription: String
    let expires: Int64
    let createdAt: Int64
    let dateEnd: Int64
    let guests: Int
    let creator: Customer
    let storiesList: [StoryItem]
    let galleryList: [GalleryItem]
    
    init(
        id: String = "",
        eventName: String = "",
        mainImage: String = "",
        qrCodeImage: String = "",
        eventDescription: String = "",
        expires: Int64 = 0,
        createdAt: Int64 = 0,
        dateEnd: Int64 = 0,
        guests: Int = 0,
        creator: Customer = Customer(),
        storiesList: [StoryItem] = [],
        galleryList: [GalleryItem] = []
    ) {
        self.id = id
        self.eventName = eventName
        self.mainImage = mainImage
        self.qrCodeImage = qrCodeImage
        self.eventDescription = eventDescription
        self.expires = expires
        self.createdAt = createdAt
        self.dateEnd = dateEnd
        self.guests = guests
        self.creator = creator
        self.storiesList = storiesList
        self.galleryList = galleryList
    }
    
    func isValid() -> Bool {
        return !id.isEmpty
    }
    
}
