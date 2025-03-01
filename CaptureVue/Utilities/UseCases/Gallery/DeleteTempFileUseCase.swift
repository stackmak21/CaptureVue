//
//  DeleteTempFileUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/2/25.
//

import Foundation

struct DeleteTempFileUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invoke(fileName: String) async -> Bool {
        return await repository.deleteTempFile(fileName: fileName)
    }
}
