//
//  AssetUploadHelper.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/2/25.
//

import Foundation
import PhotosUI
import SwiftUI
import MobileCoreServices

struct AssetUploadHelper{
    
    
    private let copyIntoTempFileUseCase: CopyIntoTempFileUseCase
    private let getAwsDirectUploadUrlUseCase: GetAwsDirectUploadUrlUseCase
    private let uploadAwsFileUseCase: UploadAwsFileUseCase
    private let notifyNewAssetUploadUseCase: NotifyNewAssetUseCase
    private let prepareUploadFileUseCase: PrepareUploadFileUseCase
    private let getPendingUploadFilesUseCase: GetPendingUploadFilesUseCase
    private let deleteTempFileUseCase: DeleteTempFileUseCase
    private let getThumbnailFromVideoUseCase: GetThumbnailFromVideoUseCase
    
    init(
        client: NetworkClient,
        galleryRepositoryMock: GalleryRepositoryContract? = nil
    ) {
        self.copyIntoTempFileUseCase = CopyIntoTempFileUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.getAwsDirectUploadUrlUseCase = GetAwsDirectUploadUrlUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.uploadAwsFileUseCase = UploadAwsFileUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.notifyNewAssetUploadUseCase = NotifyNewAssetUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.prepareUploadFileUseCase = PrepareUploadFileUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.getPendingUploadFilesUseCase = GetPendingUploadFilesUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.deleteTempFileUseCase = DeleteTempFileUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.getThumbnailFromVideoUseCase = GetThumbnailFromVideoUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
    }
    
    func uploadAwsAsset(_ token: String, selectedFiles: [PhotosPickerItem], eventId: String, section: AssetSectionType) async {
        await copyIntoTempFile(selectedFiles)
        let filesToUpload = await getAllPendingUploadFiles()
        
        for fileName in filesToUpload {
            var thumbnailName: String = ""
            let assetType: GalleryItemType = mimeTypeForPath(path: fileName).hasPrefix("image") ? .photo : .video
            if assetType == .video {
                
            }
            let uploadInfo = PrepareUploadData(
                eventId: eventId,
                fileName: fileName,
                section: section,
                assetType: assetType,
                thumbnailPublicName: ""
            )
            await getAwsDirectUploadUrl(token, uploadInfo: uploadInfo)
        }
    }
    
    func getAllPendingUploadFiles() async -> [String] {
        return await getPendingUploadFilesUseCase.invoke()
    }
    
    func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async {
        let response = await getAwsDirectUploadUrlUseCase.invoke(token, uploadInfo: uploadInfo)
        switch response {
        case .success(let response):
            print(response.url)
            await uploadAwsFile(uploadUrl: response.url, uploadInfo: uploadInfo)
            await notifyNewAssetUploadUseCase.invoke(token, assetUploadRequest: uploadInfo.toNotifyNewAssetRequest())
            await deleteTempFileUseCase.invoke(fileName: uploadInfo.fileName)
        case .failure(let error):
            print("Failed to get AWS Direct Upload Url")
        }
    }
    
    
    
//    private func getPendingUploadFile() async -> (String, GalleryItemType)? {
//        if let fileUrl = await getPendingUploadFileUseCase.invoke() {
//            print("File URL: " + fileUrl)
//            if mimeTypeForPath(path: fileUrl).hasPrefix("image"){
//                return (fileUrl, .photo)
//            }else{
//                return(fileUrl, .video)
//            }
//        }
//    }
    
    private func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async {
        await uploadAwsFileUseCase.invoke(uploadUrl: uploadUrl, uploadInfo: uploadInfo)
    }
    
    
    private func copyIntoTempFile(_ selectedFiles: [PhotosPickerItem]) async{
        // Task group
            await withTaskGroup(of: Void.self) { group in
                for selectedFile in selectedFiles {
                    group.addTask {
                        let fileDetails = await prepareUploadFileUseCase.invoke(selectedFile)
                        await copyIntoTempFileUseCase.invoke(fileDetails: fileDetails)
                    }
                }
            }
    }
    
    private func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }

    
}
