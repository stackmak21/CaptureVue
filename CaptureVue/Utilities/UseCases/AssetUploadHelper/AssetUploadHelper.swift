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



class AssetUploadHelper{
    
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
    
    var onUploadProgressUpdate: ((Int) -> Void)? = nil
    
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
    
    func uploadAwsLibraryAssets(selectedFiles: [PhotosPickerItem], eventId: String, section: AssetSectionType, onUploadProgressUpdate: ((Int) -> Void)? = nil) async {
        await copyLibraryItemsIntoTempFile(selectedFiles)
        let filesToUpload = await getAllPendingUploadFiles()
        self.onUploadProgressUpdate = onUploadProgressUpdate
        await uploadProcess(eventId: eventId, section: section, filesToUpload: filesToUpload)
    }
    
    func uploadAwsCameraAssets(selectedFiles: [UIImage], eventId: String, section: AssetSectionType, onUploadProgressUpdate: ((Int) -> Void)? = nil) async {
        await copyCameraItemsIntoTempFile(selectedFiles)
        let filesToUpload = await getAllPendingUploadFiles()
        self.onUploadProgressUpdate = onUploadProgressUpdate
        await uploadProcess(eventId: eventId, section: section, filesToUpload: filesToUpload)
    }
    
    func uploadAwsVideoFile(capturedVideoURL: URL, eventId: String, section: AssetSectionType) async {
        let fileName = capturedVideoURL.lastPathComponent
        print(fileName)
        var thumbnailName: String = ""
        if let name = await createAndUploadThumbnail(fileName: fileName, eventId: eventId){
            thumbnailName = name
        }
        let uploadInfo = PrepareUploadData(
            eventId: eventId,
            fileName: fileName,
            section: section,
            assetType: .video,
            thumbnailPublicName: thumbnailName
        )
        await getAwsDirectUploadUrl(uploadInfo)
    }
    
    
    private func uploadProcess(eventId: String, section: AssetSectionType, filesToUpload: [String]) async {
        for fileName in filesToUpload {
            var thumbnailName: String = ""
            print("FILENAME: \(fileName)")
            print("MIME TYPE: \(mimeTypeForPath(path: fileName))")
            let assetType: GalleryItemType = mimeTypeForPath(path: fileName).hasPrefix("image") ? .photo : .video
            if assetType == .video {
                if let name = await createAndUploadThumbnail(fileName: fileName, eventId: eventId){
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
            await getAwsDirectUploadUrl(uploadInfo)
        }
    }
    
    
    
    
    private func getAwsDirectUploadUrl(_ uploadInfo: PrepareUploadData) async {
        let response = await getAwsDirectUploadUrlUseCase.invoke(uploadInfo: uploadInfo)
        switch response {
        case .success(let response):
            await uploadAwsFile(uploadUrl: response.url, uploadInfo: uploadInfo, onUploadProgressUpdate: onUploadProgressUpdate)
            await notifyNewAssetUploadUseCase.invoke(assetUploadRequest: uploadInfo.toNotifyNewAssetRequest())
            let deletedSuccesfully = await deleteTempFileUseCase.invoke(fileName: uploadInfo.fileName)
            print("deleted successfully: \(deletedSuccesfully)")
        case .failure(_):
            print("Failed to get AWS Direct Upload Url")
        }
    }
    
    private func createAndUploadThumbnail( fileName: String, eventId: String) async -> String? {
        if let fileUrl = await fileManager.getFileUrl(fileName: fileName, folderName: "UploadPendingFiles"){
            let videoThumbnailImage = await getThumbnailFromVideoUseCase.invoke(url: fileUrl, at: 1)
            guard let imageData = videoThumbnailImage?.jpegData(compressionQuality: 0.4) else { return nil } // <------ Thumbnail image quallity
            let thumbnailName = "\(UUID().uuidString).jpeg"
            let uploadInfo = PrepareUploadData(eventId: eventId, fileName: thumbnailName, section: .gallery, assetType: .thumbnail, thumbnailPublicName: "")
            let response = await getAwsDirectUploadUrlUseCase.invoke(uploadInfo: uploadInfo)
            switch response {
            case .success(let response):
                await uploadAwsThumbnailUseCase.invoke(uploadUrl: response.url, uploadInfo: uploadInfo, imageData: imageData)
                await notifyNewAssetUploadUseCase.invoke(assetUploadRequest: uploadInfo.toNotifyNewAssetRequest())
                return thumbnailName
            case .failure(_):
                print("Failed to get AWS Direct Upload Url")
            }
        }
        return nil
    }
    
    
    private func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData, onUploadProgressUpdate: ((Int) -> Void)? = nil) async {
        await uploadAwsFileUseCase.invoke(uploadUrl: uploadUrl, uploadInfo: uploadInfo, onUploadProgressUpdate: onUploadProgressUpdate)
    }
    
    private func getAllPendingUploadFiles() async -> [String] {
        return await getPendingUploadFilesUseCase.invoke()
    }
    
    
    private func copyLibraryItemsIntoTempFile(_ selectedFiles: [PhotosPickerItem]) async{
        await withTaskGroup(of: Void.self) { group in
            for selectedFile in selectedFiles {
                group.addTask {
                    let fileDetails = await self.prepareUploadFileUseCase.invokeLibraryAsset(selectedFile)
                    await self.copyIntoTempFileUseCase.invoke(fileDetails: fileDetails)
                }
            }
        }
    }
    
    private func copyCameraItemsIntoTempFile(_ selectedFiles: [UIImage]) async{
        await withTaskGroup(of: Void.self) { group in
            for selectedFile in selectedFiles {
                group.addTask {
                    let fileDetails = await self.prepareUploadFileUseCase.invokeCameraAsset(.image(selectedFile))
                    await self.copyIntoTempFileUseCase.invoke(fileDetails: fileDetails)
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
