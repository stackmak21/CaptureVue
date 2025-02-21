//
//  GalleryRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

protocol GalleryRepositoryContract {
    func fetchAwsDirectUploadURL(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError>

}
