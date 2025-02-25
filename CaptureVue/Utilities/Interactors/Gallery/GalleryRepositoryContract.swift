//
//  GalleryRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

protocol GalleryRepositoryContract {
    func fetchAwsDirectUploadURL(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError>
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async -> String
    func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueError>
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueError
}
