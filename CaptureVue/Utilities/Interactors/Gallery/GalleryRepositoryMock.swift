//
//  GalleryRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct GalleryRepositoryMock: GalleryRepositoryContract {
    func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueError> {
        return .success(AwsDirectUploadUrl(url: "fdfd"))
    }
  
    
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async {
        
    }
    
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueError { return CaptureVueErrorDto(msg: nil, code: nil, reason: nil).toCaptureVueError()}
    

    func fetchAwsDirectUploadURL(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError> {
        return .success(AwsDirectUploadUrl(url: "fdf"))
    }
    
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async -> String {
        return ""
    }

}
