//
//  NotifyNewAssetUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/2/25.
//

import Foundation

struct NotifyNewAssetUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invoke(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueResponseRaw {
        return await repository.notifyNewAssetUpload(token, assetUploadRequest: assetUploadRequest)
    }
}
