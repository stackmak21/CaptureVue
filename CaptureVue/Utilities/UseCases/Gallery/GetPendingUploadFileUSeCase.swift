//
//  GetPendingUploadFileUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/2/25.
//

import Foundation

struct GetPendingUploadFilesUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invoke() async -> [String] {
        return await repository.getPendingUploadFiles()
    }
}
