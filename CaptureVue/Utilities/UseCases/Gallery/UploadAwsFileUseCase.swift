//
//  UploadAwsFileUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/2/25.
//

import Foundation

struct UploadAwsFileUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invoke(uploadUrl: String, uploadInfo: PrepareUploadData, onUploadProgressUpdate: ((Int) -> Void)? = nil) async {
        return await repository.uploadAwsFile(uploadUrl: uploadUrl, uploadInfo: uploadInfo, onUploadProgressUpdate: onUploadProgressUpdate)
    }
}
