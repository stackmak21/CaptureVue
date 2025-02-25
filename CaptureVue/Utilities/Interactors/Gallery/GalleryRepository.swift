//
//  GalleryRepository.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct GalleryRepository: GalleryRepositoryContract {
    
    private let galleryApi: GalleryApi
    private let fileManager: LocalFileManager = LocalFileManager.instance
    
    init(client: NetworkClient) {
        self.galleryApi = GalleryApi(client: client)
    }
    
    func fetchAwsDirectUploadURL(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError> {
        return await galleryApi.fetchAwsDirectUploadUrl(
            token: token,
            eventId: uploadInfo.eventId,
            section: uploadInfo.section,
            filename: uploadInfo.filename
        )
        .map({ $0.toAwsDirectUploadUrl() })
        .mapError({ $0.toCaptureVueError() })
    }
    
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async -> String {
        let uniqueString = UUID().uuidString
        await fileManager.saveFile(file: selectedFile, fileName: "\(uniqueString).\(identifier)", folderName: "UploadPendingFiles")
        if  let fileName = await fileManager.getFileUrl(fileName: "\(uniqueString).\(identifier)", folderName: "UploadPendingFiles") {
            return fileName.absoluteString
        }
        return ""
    }
    
    func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueError> {
        return await galleryApi.getAwsDirectUploadUrl(
            token: token,
            uploadInfo: uploadInfo
        )
        .map({$0.toAwsDirectUploadUrl()})
        .mapError({$0.toCaptureVueError()})
    }
    
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async {
        await galleryApi.uploadAwsFile(uploadUrl: uploadUrl, uploadInfo: uploadInfo)
        
    }
    
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueError {
        return await galleryApi.notifyNewAssetUpload(token, assetUploadRequest: assetUploadRequest).toCaptureVueError()
    }
    
}



