//
//  EventViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import Foundation
import AVKit
import SwiftfulRouting
import SwiftUI
import PhotosUI
import MobileCoreServices



@MainActor
class EventViewModel: BaseViewModel {
    
    @KeychainStorage(.token) var token = ""
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    private let fetchEventUseCase: FetchEventUseCase
    private let copyIntoTempFileUseCase: CopyIntoTempFileUseCase
    private let getAwsDirectUploadUrlUseCase: GetAwsDirectUploadUrlUseCase
    private let uploadAwsFileUseCase: UploadAwsFileUseCase
    private let notifyNewAssetUploadUseCase: NotifyNewAssetUseCase
    
    let eventId: String
    var videoUrl: String = ""
    private var fileUrl = "" {
        didSet{
            if !fileUrl.isEmpty{
                getAwsDirectUploadUrl()
            }
        }
    }
    
    @Published var event: Event = Event()
    @Published var isLoading: Bool = false
    
    @Published var selectedFiles: [PhotosPickerItem] = [] {
        didSet{
            if !selectedFiles.isEmpty{
                copyIntoTempFile(selectedFiles)
            }
        }
    }
    
    
    init(
        router: AnyRouter,
        client: NetworkClient,
        eventRepositoryMock: EventRepositoryContract? = nil,
        galleryRepositoryMock: GalleryRepositoryContract? = nil,
        eventId: String
    ) {
        self.router = router
        self.client = client
        self.eventId = eventId
        self.fetchEventUseCase = FetchEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
        self.copyIntoTempFileUseCase = CopyIntoTempFileUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.getAwsDirectUploadUrlUseCase = GetAwsDirectUploadUrlUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.uploadAwsFileUseCase = UploadAwsFileUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.notifyNewAssetUploadUseCase = NotifyNewAssetUseCase(client: client, galleryRepositoryMock: galleryRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func fetchEvent() {
        let task = Task{
            setLoading()
            defer { resetLoading() }
            let response = await fetchEventUseCase.invoke(eventId, token)
            switch response {
            case .success(let fetchedEvent):
                self.event = fetchedEvent
            case .failure(let error):
                Banner(router: router, message: error.msg , bannerType: .error, bannerDuration: .long, action: nil)
            }
        }
        tasks.append(task)
    }
    
    func copyIntoTempFile(_ selectedFiles: [PhotosPickerItem]){
        // Task group

        let task = Task{
            await withTaskGroup(of: String.self) { taskGroup in
                for file in selectedFiles{
                    taskGroup.addTask {
                        let (fileData, identifier) = await self.prepareFile(file: file)
                        return await self.copyIntoTempFileUseCase.invoke(fileData, identifier: identifier)
                    }
                }
                
                for await result in taskGroup{
                    self.fileUrl = result
                }
            }
            
           
        }
        tasks.append(task)
        
//        // Concurrent process
//        selectedFiles.forEach { file in
//            Task{
//                let (fileData, identifier) = await prepareFile(file: file)
//                await copyIntoTempFileUseCase.invoke(fileData, identifier: identifier)
//            }
//        }
//        
//        // Sequential process
//        Task{
//            for file in selectedFiles{
//                let (fileData, identifier) = await prepareFile(file: file)
//                await copyIntoTempFileUseCase.invoke(fileData, identifier: identifier)
//            }
//        }
    }
    
    func getAwsDirectUploadUrl() -> Void {
        let task = Task{
            let serverResponse = await getAwsDirectUploadUrlUseCase.invoke(token, uploadInfo: PrepareUploadData(eventId: eventId, fileUrl: fileUrl, section: .gallery, assetType: .photo, thumbnailPublicName: ""))
            switch serverResponse {
            case .success(let response):
                print(response.url)
                await uploadAwsFileUseCase.invoke(uploadUrl: response.url, uploadInfo: PrepareUploadData(eventId: eventId, fileUrl: fileUrl, section: .gallery, assetType: .photo, thumbnailPublicName: ""))
                await notifyNewAssetUploadUseCase.invoke(token, assetUploadRequest: PrepareUploadData(eventId: eventId, fileUrl: fileUrl, section: .gallery, assetType: .photo, thumbnailPublicName: "").toNotifyNewAssetRequest())
            case .failure(let error):
                print("error aws direct upload url")
            }
        }
        tasks.append(task)
    }
    
    
    func prepareFile(file: PhotosPickerItem) async -> (Data, String) {
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
    
    
    private func getFileExtension(from identifier: String) -> String {
        if let type = UTType(identifier) {
            return type.preferredFilenameExtension ?? "unknown"
        }
        return "unknown"
    }
    

    
    
    
    
}


enum GalleryItemType: Int{
    case photo = 0
    case video = 1
    case thumbnail = 2
}

enum AssetSectionType: String {
    case story
    case gallery
}





