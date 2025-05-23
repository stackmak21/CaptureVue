//
//  CopyTempFileUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/2/25.
//

import Foundation

struct CopyIntoTempFileUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invoke(fileDetails: (fileData: Data, identifier: String)) async  {
        return await repository.copyIntoTempFile(fileDetails.fileData, identifier: fileDetails.identifier)
    }
}
