//
//  GetThumbnailFromVideoUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 28/2/25.
//

import Foundation
import SwiftUI

struct GetThumbnailFromVideoUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invoke(url: URL, at: TimeInterval) async -> UIImage? {
        return await repository.getThumbnailFromVideo(url: url, at: at)
    }
}
