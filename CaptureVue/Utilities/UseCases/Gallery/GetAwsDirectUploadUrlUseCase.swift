//
//  GetAwsDirectUploadUrlUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/2/25.
//

import Foundation

struct GetAwsDirectUploadUrlUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invoke(uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueResponseRaw> {
        return await repository.getAwsDirectUploadUrl(uploadInfo: uploadInfo)
    }
}
