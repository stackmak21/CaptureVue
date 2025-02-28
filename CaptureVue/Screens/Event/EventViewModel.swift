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
    private let assetUploadHelper: AssetUploadHelper
    
    let eventId: String
    var videoUrl: String = ""
    private var fileName = "" {
        didSet{
            if !fileName.isEmpty{
                getAwsDirectUploadUrl()
            }
        }
    }
    
    @Published var event: Event = Event()
    @Published var isLoading: Bool = false
    
    @Published var selectedFiles: [PhotosPickerItem] = [] {
        didSet{
            if !selectedFiles.isEmpty{
                uploadFiles(selectedFiles)
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
        self.assetUploadHelper = AssetUploadHelper(client: client, galleryRepositoryMock: galleryRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
        print("View Model Deinit")
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
    
    func uploadFiles(_ selectedFiles: [PhotosPickerItem]){
        Task{
           await assetUploadHelper.uploadAwsAsset(token, selectedFiles: selectedFiles, eventId: eventId, section: .gallery)
        }

    }
    
    func getAwsDirectUploadUrl() -> Void {
        let task = Task{
            let serverResponse = await getAwsDirectUploadUrlUseCase.invoke(token, uploadInfo: PrepareUploadData(eventId: eventId, fileName: fileName, section: .gallery, assetType: .photo, thumbnailPublicName: ""))
            switch serverResponse {
            case .success(let response):
                print(response.url)
                await uploadAwsFileUseCase.invoke(uploadUrl: response.url, uploadInfo: PrepareUploadData(eventId: eventId, fileName: fileName, section: .gallery, assetType: .photo, thumbnailPublicName: ""))
                await notifyNewAssetUploadUseCase.invoke(token, assetUploadRequest: PrepareUploadData(eventId: eventId, fileName: fileName, section: .gallery, assetType: .photo, thumbnailPublicName: "").toNotifyNewAssetRequest())
            case .failure(let error):
                print("error aws direct upload url")
            }
        }
        tasks.append(task)
    }
    
    

    

    
    
    
    
}







