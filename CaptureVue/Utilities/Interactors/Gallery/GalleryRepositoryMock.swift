//
//  GalleryRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct GalleryRepositoryMock: GalleryRepositoryContract {

    func fetchAwsDirectUploadURL(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError> {
        return .success(AwsDirectUploadUrl(url: "fdf"))
    }

}
