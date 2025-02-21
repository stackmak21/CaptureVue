//
//  StoryItemDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct StoryItemDto: Codable, Identifiable{
    
    let id: String?
    let url: String?
    let previewUrl: String?
    let type: MediaType?
    let creator: CustomerDto?
    var isSeen: Bool? = false
    
    
    enum CodingKeys: String, CodingKey{
        case id
        case url
        case previewUrl
        case type
        case creator
    }
    
    func toStoryItem() -> StoryItem {
        return StoryItem(
            id: self.id ?? "",
            url: self.url ?? "",
            previewUrl: self.previewUrl ?? "",
            type: self.type ?? .photo,
            creator: self.creator?.toCustomer() ?? Customer(),
            isSeen: self.isSeen ?? false
        )
    }
}
