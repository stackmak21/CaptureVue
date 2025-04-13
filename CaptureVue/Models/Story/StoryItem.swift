//
//  StoryItem.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct StoryItem: Identifiable{
    
    let id: String
    let url: String
    let previewUrl: String
    let type: MediaType
    let creator: Customer
    var isSeen: Bool
    
    init(
        id: String = "",
        url: String = "",
        previewUrl: String = "",
        type: MediaType = .photo,
        creator: Customer = Customer(),
        isSeen: Bool = false
    ) {
        self.id = id
        self.url = url
        self.previewUrl = previewUrl
        self.type = type
        self.creator = creator
        self.isSeen = isSeen
    }
    
    var previewImage: String {
        if self.type == .photo {
            return self.url
        }else{
            return self.previewUrl
        }
    }
    
    var isVideo: Bool {
        return self.type == .video
    }
}
