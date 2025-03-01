//
//  AssetUploadHelper.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/2/25.
//

import Foundation
import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct AssetUploadHelper{
    
    
    private let copyIntoTempFileUseCase: CopyIntoTempFileUseCase
    private let getAwsDirectUploadUrlUseCase: GetAwsDirectUploadUrlUseCase
    private let uploadAwsFileUseCase: UploadAwsFileUseCase
    private let notifyNewAssetUploadUseCase: NotifyNewAssetUseCase
    private let prepareUploadFileUseCase: PrepareUploadFileUseCase
    private let getPendingUploadFilesUseCase: GetPendingUploadFilesUseCase
    private let deleteTempFileUseCase: DeleteTempFileUseCase
    private let getThumbnailFromVideoUseCase: GetThumbnailFromVideoUseCase
    private let uploadAwsThumbnailUseCase: UploadThumbnailUseCase
    private let fileManager: LocalFileManager = LocalFileManager.instance
    
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
        self.uploadAwsThumbnailUseCase = UploadThumbnailUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
    }
    
    func uploadAwsAsset(_ token: String, selectedFiles: [PhotosPickerItem], eventId: String, section: AssetSectionType) async {
        await copyIntoTempFile(selectedFiles)
        let filesToUpload = await getAllPendingUploadFiles()
        
        for fileName in filesToUpload {
            var thumbnailName: String = ""
            let assetType: GalleryItemType = mimeTypeForPath(path: fileName).hasPrefix("image") ? .photo : .video
            if assetType == .video {
                if let name = await createAndUploadThumbnail(token: token, fileName: fileName, eventId: eventId){
                    thumbnailName = name
                }
            }
            let uploadInfo = PrepareUploadData(
                eventId: eventId,
                fileName: fileName,
                section: section,
                assetType: assetType,
                thumbnailPublicName: thumbnailName
            )
            await getAwsDirectUploadUrl(token, uploadInfo: uploadInfo)
        }
    }
    
    
    
    
    
    private func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async {
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
    
    private func createAndUploadThumbnail(token: String, fileName: String, eventId: String) async -> String? {
        if let fileUrl = await fileManager.getFileUrl(fileName: fileName, folderName: "UploadPendingFiles"){
            let videoThumbnailImage = await getThumbnailFromVideoUseCase.invoke(url: fileUrl, at: 1)
            guard let imageData = videoThumbnailImage?.jpegData(compressionQuality: 1) else { return nil }
            let thumbnailName = "\(UUID().uuidString).jpeg"
            let uploadInfo = PrepareUploadData(eventId: eventId, fileName: thumbnailName, section: .gallery, assetType: .thumbnail, thumbnailPublicName: "")
            let response = await getAwsDirectUploadUrlUseCase.invoke(token, uploadInfo: uploadInfo)
            switch response {
            case .success(let response):
                await uploadAwsThumbnailUseCase.invoke(uploadUrl: response.url, uploadInfo: uploadInfo, imageData: imageData)
                await notifyNewAssetUploadUseCase.invoke(token, assetUploadRequest: uploadInfo.toNotifyNewAssetRequest())
                return thumbnailName
            case .failure(_):
                print("Failed to get AWS Direct Upload Url")
            }
        }
        return nil
    }

    
    private func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async {
        await uploadAwsFileUseCase.invoke(uploadUrl: uploadUrl, uploadInfo: uploadInfo)
    }
    
    private func getAllPendingUploadFiles() async -> [String] {
        return await getPendingUploadFilesUseCase.invoke()
    }
    
    
    private func copyIntoTempFile(_ selectedFiles: [PhotosPickerItem]) async{
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
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        if let uti = UTType(filenameExtension: pathExtension),
           let mimeType = uti.preferredMIMEType {
            return mimeType
        }
        return "application/octet-stream"
    }

    
}
