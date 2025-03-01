//
//  GalleryRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct GalleryRepositoryMock: GalleryRepositoryContract {
    func uploadAwsThumbnail(uploadUrl: String, uploadInfo: PrepareUploadData, imageData: Data) async {
        
    }
    
    
    func getThumbnailFromVideo(url: URL, at time: TimeInterval) async -> UIImage? {
        return .image1
    }
    
    func deleteTempFile(fileName: String) async -> Bool {
        return true
    }
    
    func prepareUploadFile(file: PhotosPickerItem) async -> (Data, String) {
        return (Data(), "")
    }
    
    func getPendingUploadFiles() async -> [String] {
        return []
    }
    
    func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueResponseRaw> {
        return .success(AwsDirectUploadUrl(url: "fdfd"))
    }
  
    
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async {
        
    }
    
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueResponseRaw { return CaptureVueResponseRaw(msg: nil, code: nil, reason: nil)}
    
    
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async {
        
    }

}
