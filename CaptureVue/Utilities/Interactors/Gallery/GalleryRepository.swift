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
    
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async {
        let uniqueString = UUID().uuidString
        await fileManager.saveFile(file: selectedFile, fileName: "\(uniqueString).\(identifier)", folderName: "UploadPendingFiles")
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
    
    func prepareUploadFile(file: PhotosPickerItem) async -> (Data, String) {
        var fileData = Data()
        var identifier = ""
        do{
            if let uti = file.supportedContentTypes.first?.identifier {
                identifier = getFileExtension(from: uti)
            }
            if let data = try? await file.loadTransferable(type: Data.self){
                fileData = data
            }
        }
        return (fileData, identifier)
    }
    
    func getThumbnailFromVideo(url: URL, at time: TimeInterval) async -> UIImage?{
        
        do{
            let asset = AVURLAsset(url: url)
            
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            assetImageGenerator.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
            
            let cmTime = CMTime(seconds: time, preferredTimescale: 60)
            let thumbnailImage = try await assetImageGenerator.image(at: cmTime).image
            return UIImage(cgImage: thumbnailImage)
        }
        catch{
            print("Error catching thumbnail from video")
            return nil
        }
    }
    
    private func getFileExtension(from identifier: String) -> String {
        if let type = UTType(identifier) {
            return type.preferredFilenameExtension ?? "unknown"
        }
        return "unknown"
    }
    
    func getPendingUploadFiles() async -> [String] {
        return await fileManager.getAllFiles(folderName: "UploadPendingFiles")
    }
    
    func deleteTempFile(fileName: String) async -> Result<Bool, Never> {
        return await fileManager.deleteFile(fileName: fileName, folderName: "UploadPendingFiles")
    }
    
}



