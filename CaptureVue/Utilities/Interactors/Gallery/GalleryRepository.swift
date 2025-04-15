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
    
 
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async {
        let uniqueString = UUID().uuidString
        await fileManager.saveFile(file: selectedFile, fileName: "\(uniqueString).\(identifier)", folderName: "UploadPendingFiles")
    }
    
    func getPendingUploadFiles() async -> [String] {
        return await fileManager.getAllFiles(folderName: "UploadPendingFiles")
    }
    
    func getAwsDirectUploadUrl(uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueResponseRaw> {
        return await galleryApi.getAwsDirectUploadUrl(
            uploadInfo: uploadInfo
        )
        .map({$0.toAwsDirectUploadUrl()})
        .mapError({ $0 })
    }
    
    func prepareUploadFile(file: PhotosPickerItem) async -> (Data, String) {
        var fileData = Data()
        var identifier = ""
        do{
            if let uti = file.supportedContentTypes.first?.identifier {
                identifier = getFileExtension(from: uti)
            }
            if let data = try? await file.loadTransferable(type: Data.self){
                let uiImage = UIImage(data: data)
                if let data = uiImage?.jpegData(compressionQuality: 0.6){  // Reduced compression quallity because iphone save them as HEIC
                    fileData = data
                }
                else{
                    fileData = data
                }
            }
        }
        log.warning("\(#function)\(fileData.count)")
        return (fileData, identifier)
    }
    
    func prepareUploadCameraFile(file: CameraAsset) async -> (Data, String) {
        switch file {
        case .image(let image):
            if let imageData = image.jpegData(compressionQuality: 1){
                return (imageData, "jpeg")
            }
        case .video(let video): // To Do Later
            return (Data(), "mov")
        }
        return (Data(), "mov")
    }
    
    
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData, onUploadProgressUpdate: ((Int) -> Void)? = nil) async {
        await galleryApi.uploadAwsFile(uploadUrl: uploadUrl, uploadInfo: uploadInfo, onUploadProgressUpdate: onUploadProgressUpdate)
        
    }
    
    func notifyNewAssetUpload(assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueResponseRaw {
        return await galleryApi.notifyNewAssetUpload(assetUploadRequest: assetUploadRequest)
    }
    
    func deleteTempFile(fileName: String) async -> Bool {
        return await fileManager.deleteFile(fileName: fileName, folderName: "UploadPendingFiles")
    }
    
    func uploadAwsThumbnail(uploadUrl: String, uploadInfo: PrepareUploadData, imageData: Data) async {
        await galleryApi.uploadAwsThumbnail(uploadUrl: uploadUrl, uploadInfo: uploadInfo, imageData: imageData)
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
        catch(let error){
            print("Error catching thumbnail from video")
            print("\(error.localizedDescription)")
            return nil
        }
    }
    
    private func getFileExtension(from identifier: String) -> String {
        if let type = UTType(identifier) {
            return type.preferredFilenameExtension ?? "unknown"
        }
        return "unknown"
    }
    
    
    
    
    
}



