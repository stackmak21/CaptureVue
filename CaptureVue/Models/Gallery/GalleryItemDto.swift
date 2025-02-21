//
//  GalleryItemDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct GalleryItemDto: Codable {
    let id: String?
    let publicUrl: String?
    let creatorId: String?
    let createdAt: Int64?
    let eventId: String?
    let dataType: MediaType?
    let previewUrl: String?
    let customer: CustomerDto?
    
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
    
    func toGalleryItem() -> GalleryItem {
        return GalleryItem(
            id: self.id ?? "",
            publicUrl: self.publicUrl ?? "",
            creatorId: self.creatorId ?? "",
            createdAt: self.createdAt ?? 0,
            eventId: self.eventId ?? "",
            dataType: self.dataType ?? .photo,
            previewUrl: self.previewUrl ?? "",
            customer: self.customer?.toCustomer() ?? Customer()
        )
    }
}
