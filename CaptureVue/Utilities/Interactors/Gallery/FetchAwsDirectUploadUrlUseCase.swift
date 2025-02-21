//
//  FetchAwsDirectUploadUrlUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct FetchAwsDirectUploadUrlUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(repository: GalleryRepositoryContract) { self.repository = repository }
    
    func invoke(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError> {
        return await repository.fetchAwsDirectUploadURL(token, uploadInfo)
    }
}
