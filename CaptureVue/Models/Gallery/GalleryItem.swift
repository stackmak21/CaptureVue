//
//  GalleryItem.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct GalleryItem: Identifiable {
    
    let id: String
    let publicUrl: String
    let creatorId: String
    let createdAt: Int64
    let eventId: String
    let dataType: MediaType
    let previewUrl: String
    let customer: Customer
    
    init(
        id: String = "",
        publicUrl: String = "",
        creatorId: String = "",
        createdAt: Int64 = 0,
        eventId: String = "",
        dataType: MediaType = .photo,
        previewUrl: String = "",
        customer: Customer = Customer()
    ) {
        self.id = id
        self.publicUrl = publicUrl
        self.creatorId = creatorId
        self.createdAt = createdAt
        self.eventId = eventId
        self.dataType = dataType
        self.previewUrl = previewUrl
        self.customer = customer
    }
    
    var previewImage: String {
        if self.dataType == .photo {
            return self.publicUrl
        }else{
            return self.previewUrl
        }
    }
    
    var isVideo: Bool {
        return self.dataType == .video
    }
}
