//
//  GalleryRepository.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct GalleryRepository: GalleryRepositoryContract {
    
    
    private let galleryApi: GalleryApi
    
    init(client: NetworkClient) {
        self.galleryApi = GalleryApi(client: client)
    }
    
    func fetchAwsDirectUploadURL(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError> {
        return await galleryApi.fetchAwsDirectUploadUrl(
            token: token,
            eventId: uploadInfo.eventId,
            section: uploadInfo.section.rawValue,
            filename: uploadInfo.filename
        )
        .map({ $0.toAwsDirectUploadUrl() })
        .mapError({ $0.toCaptureVueError() })
    }
    
}



