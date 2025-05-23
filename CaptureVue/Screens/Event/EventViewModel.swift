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
    
    
    let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let keychain: KeychainManager = KeychainManager()
    private let client: NetworkClient
    private let updateUsernameUseCase: UpdateUsernameUseCase
    private let fetchEventUseCase: FetchEventUseCase
    private let assetUploadHelper: AssetUploadHelper
    private let assetDownloadHelper: AssetDownloadHelper
    
    let eventId: String
    var videoUrl: String = ""
    
    @Published var myString: String = ""
    
    @Published var stories: [StoryBundle] = []
    
    
    @Published var event: Event = Event() {
        didSet{
            stories = event.storyBundles
        }
    }
    @Published var isLoading: Bool = false
    
    @Published var isMediaPickerPresented: Bool = false
    @Published var isPhotoPickerPresented: Bool = false
    @Published var isCameraPresented: Bool = false
    
    @Published var uploadProgress: Double = 0
    @Published var filesToUpload: Int = 0
    
    @Published var isUsernameSheetPresented: Bool = false
    
    @Published var username: String = ""
    
    @Published var selectedFiles: [PhotosPickerItem] = [] {
        didSet{ usernameCheck() }
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
        downloadRepositoryMock: DownloadRepositoryMock? = nil,
        authRepositoryMock: AuthRepositoryMock? = nil,
        eventId: String
    ) {
        self.router = router
        self.client = client
        self.eventId = eventId
        self.fetchEventUseCase = FetchEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
        self.assetUploadHelper = AssetUploadHelper(client: client, galleryRepositoryMock: galleryRepositoryMock)
        self.assetDownloadHelper = AssetDownloadHelper(client: client, downloadRepositoryMock: downloadRepositoryMock)
        self.updateUsernameUseCase = UpdateUsernameUseCase(client: client, authRepositoryMock: authRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
        print("View Model Deinit")
    }
    
    func usernameCheck() {
        if let user: Customer =  keychain.getData(key: .customer) {
            print("User first name: \(user.firstName.isEmpty)  &&  User isGuest: \(user.isGuest)")
            if user.firstName.isEmpty && !user.isGuest{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                    self.isUsernameSheetPresented = true
                }
            }
            else{
                uploadSelectedGalleryFiles()
            }
        }
    }
    
    func onUsernameSubmit(username: String){
        let task = Task{
            setLoading()
            defer { resetLoading() }
            let response = await updateUsernameUseCase.invoke(username)
            switch response {
            case .success(let updateUsernameResponse):
                keychain.saveData(updateUsernameResponse.guestCustomer, key: .customer)
                isUsernameSheetPresented = false
                usernameCheck()
            case .failure(let error):
                Banner(message: error.msg ?? "" , bannerType: .error, bannerDuration: .long, action: nil)
            }
        }
        
        tasks.append(task)
    }
    
    func uploadSelectedGalleryFiles(){
        filesToUpload = selectedFiles.count
        if !selectedFiles.isEmpty{
            uploadFiles(selectedFiles, section: .gallery)
        }
    }
    
    func openCamera(){
        isMediaPickerPresented = false
        router.showScreen(.push) { router in
            CaptureCameraView(
                router: router,
                onCapture: { image in
                    self.uploadFiles([image], section: .story)
                    print("imageeeeeeeee")
                },
                onVideoCapture: { videoURL in
                    self.uploadVideo(videoURL, section: .story)
                }
            )
        }
    }
    

    
    func fetchCustomerEvent() {
            let task = Task{
                setLoading()
                defer { resetLoading() }
                let response = await fetchEventUseCase.invoke(eventId)
                switch response {
                case .success(let fetchedEvent):
                    self.event = fetchedEvent
                case .failure(let error):
                    Banner(message: error.msg ?? "" , bannerType: .error, bannerDuration: .long, action: nil)
                }
            }

        tasks.append(task)
    }
    
    func uploadFiles(_ selectedFiles: [PhotosPickerItem], section: AssetSectionType){
        let task = Task{
                await assetUploadHelper.uploadAwsLibraryAssets(
                    selectedFiles: selectedFiles,
                    eventId: eventId,
                    section: section,
                    onUploadProgressUpdate: { [weak self] progress in
                        print("progresss: \(progress)")
                        Task { @MainActor in
                            self?.uploadProgress = Double(progress)
                        }
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
                    capturedVideoURL: videoURL,
                    eventId: eventId,
                    section: section
                )
                fetchCustomerEvent()
        }
        tasks.append(task)
    }
    
    func downloadAsset(assetURL: String, assetType: MediaType){
        let task = Task{
            await assetDownloadHelper.downloadAsset(assetURL: assetURL, assetType: assetType)
        }
        tasks.append(task)
    }
    
    
    func openPhotoLibrary(){
        isMediaPickerPresented = false
        isPhotoPickerPresented = true
    }
    
}


//MARK: - Navigation

extension EventViewModel{
    
    func goBack(){
        router.dismissScreen()
    }
    
    func showAlert(){
        router.showAlert(.alert, title: "Title", subtitle: "Subtitle") {
            TextField("TextField", text: Binding(get: { self.myString }, set: { self.myString = $0 }))
        }
    }
    
    func uploadBanner(){
        router.showModal(
            transition: .move(edge: .bottom),
            animation: .easeInOut(duration: 0.2),
            alignment: .center,
            backgroundColor: .black.opacity(0.1),
            dismissOnBackgroundTap: true,
            ignoreSafeArea: true,
            destination: {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 200, height: 200)
            }
        )
    }
}
