//
//  PrepareUploadData.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/2/25.
//

import Foundation

struct PrepareUploadData {
    let eventId: String
    let fileUrl: String
    let section: AssetSectionType
    let assetType: GalleryItemType
    let thumbnailPublicName: String
    
    func toNotifyNewAssetRequest() -> NotifyNewAssetRequest {
        return NotifyNewAssetRequest(
            assetKey: self.fileUrl,
            section: self.section.rawValue,
            assetType: self.assetType.rawValue,
            eventId: self.eventId,
            thumbnailKey: self.thumbnailPublicName
        )
    }
}


struct NotifyNewAssetRequest: Codable {
    let assetKey: String
    let section: String
    let assetType: Int
    let eventId: String
    let thumbnailKey: String
}
