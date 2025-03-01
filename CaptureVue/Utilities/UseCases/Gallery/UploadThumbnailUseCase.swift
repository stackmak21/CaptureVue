//
//  UploadThumbnailUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 28/2/25.
//

import Foundation

struct UploadThumbnailUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }

    func invoke(uploadUrl: String, uploadInfo: PrepareUploadData, imageData: Data) async  {
        return await repository.uploadAwsThumbnail(uploadUrl: uploadUrl, uploadInfo: uploadInfo, imageData: imageData)
    }
}
