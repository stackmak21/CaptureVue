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
    private let assetUploadHelper: AssetUploadHelper
    
    let eventId: String
    var videoUrl: String = ""
    
    
    @Published var event: Event = Event()
    @Published var isLoading: Bool = false
    
    @Published var isMediaPickerPresented: Bool = false
    @Published var isPhotoPickerPresented: Bool = false
    @Published var isCameraPresented: Bool = false
    
    @Published var uploadProgress: Double = 0
    @Published var filesToUpload: Int = 0
    
    @Published var selectedFiles: [PhotosPickerItem] = [] {
        didSet{
            filesToUpload = selectedFiles.count
            if !selectedFiles.isEmpty{
                uploadFiles(selectedFiles, section: .gallery)
            }
        }
    }
    
    @Published var selectedStoryItem: [PhotosPickerItem] = [] {
        didSet{
            filesToUpload = selectedStoryItem.count
            if !selectedStoryItem.isEmpty{
                uploadFiles(selectedStoryItem, section: .story)
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
        self.assetUploadHelper = AssetUploadHelper(client: client, galleryRepositoryMock: galleryRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
        print("View Model Deinit")
    }
    
    func openCamera(){
        isMediaPickerPresented = false
        router.showScreen(.push) { router in
            CaptureCameraView(
                router: router,
                onCapture: { image in
                    self.uploadFiles([image], section: .gallery)
                },
                onVideoCapture: { videoURL in
                    self.uploadVideo(videoURL, section: .story)
                }
            )
        }
    }
    
    func goBack(){
        router.dismissScreen()
    }
    
    func fetchCustomerEvent() {
            let task = Task{
                setLoading()
                defer { resetLoading() }
                let response = await fetchEventUseCase.invoke(eventId, token)
                switch response {
                case .success(let fetchedEvent):
                    self.event = fetchedEvent
                case .failure(let error):
                    Banner(router: router, message: error.msg ?? "" , bannerType: .error, bannerDuration: .long, action: nil)
                }
            }

        tasks.append(task)
    }
    
    func uploadFiles(_ selectedFiles: [PhotosPickerItem], section: AssetSectionType){
        let task = Task{
                await assetUploadHelper.uploadAwsLibraryAssets(
                    token,
                    selectedFiles: selectedFiles,
                    eventId: eventId,
                    section: section,
                    onUploadProgressUpdate: { [weak self] progress in
                        self?.uploadProgress = Double(progress)
                    }
                )
                filesToUpload = 0
                fetchCustomerEvent()
        }
        tasks.append(task)
    }
    
    func uploadFiles(_ selectedFiles: [UIImage], section: AssetSectionType){
        let task = Task{
                await assetUploadHelper.uploadAwsCameraAssets(
                    token,
                    selectedFiles: selectedFiles,
                    eventId: eventId,
                    section: section,
                    onUploadProgressUpdate: { [weak self] progress in
                        self?.uploadProgress = Double(progress)
                    }
                )
                filesToUpload = 0
                fetchCustomerEvent()
        }
        tasks.append(task)
    }
    
    func uploadVideo(_ videoURL: URL, section: AssetSectionType){
        let task = Task{
            await assetUploadHelper.uploadAwsVideoFile(
                    token,
                    capturedVideoURL: videoURL,
                    eventId: eventId,
                    section: section
                )
                fetchCustomerEvent()
        }
        tasks.append(task)
    }
    
    
    func openPhotoLibrary(){
        isMediaPickerPresented = false
        isPhotoPickerPresented = true
    }
    
}
