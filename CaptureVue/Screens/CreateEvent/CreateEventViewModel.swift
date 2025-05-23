//
//  HomeViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation
import SwiftfulRouting
import SwiftUI


struct CreateEventDraft: Codable {
    var eventName: String = ""
    var eventImage: Data = Data()
    var eventDescription: String = ""
    var authorizeGuests: Bool = false
    var guestsGallery: Bool = false
    var guestsNum: Int = 0
    var startDate: Date = .now
    var endDate: Date = .now
}


@MainActor
class CreateEventViewModel: BaseViewModel {
   
    let router: AnyRouter
    private let keychain: KeychainManager = KeychainManager()
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    // Use Cases
    private let createEventUseCase: CreateEventUseCase
    private let updateUsernameUseCase: UpdateUsernameUseCase
    
    
    @Published var isLoading: Bool = false
    
    @Published var eventName: String = "Paris Birthday"
    @Published var eventImage: UIImage?
    @Published var eventDescription: String = ""
    @Published var authorizeGuests: Bool = false
    @Published var guestsGallery: Bool = false
    @Published var guestsNum: Int = 0
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    
    @Published var videoURL: URL?
    
    
    @Published var draft: CreateEventDraft = CreateEventDraft()
    
    @Published var isUsernameSheetPresented: Bool = false
    @Published var username: String = ""
    
    

    
    init(
        router: AnyRouter,
        client: NetworkClient,
        eventRepositoryMock: EventRepositoryContract? = nil,
        authRepositoryMock: AuthRepositoryMock? = nil
    ) {
        self.router = router
        self.client = client
        self.createEventUseCase = CreateEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
        self.updateUsernameUseCase = UpdateUsernameUseCase(client: client, authRepositoryMock: authRepositoryMock)
        getDraft()
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }

    
    func publishEvent() {
        let task = Task{
            setLoading()
            defer{ resetLoading() }
                if let eventImageData = eventImage?.jpegData(compressionQuality: 0.8){
                    let createEventResponse =  await createEventUseCase.invoke(createEventRequestBuilder(), eventImageData)
                    switch createEventResponse {
                    case .success(let response):
                        router.dismissScreen()
                    case .failure(let error):
                        Banner(message: error.msg ?? "", bannerType: .error, bannerDuration: .long, action: nil)
                    }
                }
                else{
                    Banner(message: "Failed to create Data from Image", bannerType: .error, bannerDuration: .long, action: nil)
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
                publishEvent()
            case .failure(let error):
                Banner(message: error.msg ?? "" , bannerType: .error, bannerDuration: .long, action: nil)
            }
        }
        tasks.append(task)
    }
    
    
    func usernameCheck() {
        if let user: Customer =  keychain.getData(key: .customer) {
            if user.firstName.isEmpty && !user.isGuest{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                    self.isUsernameSheetPresented = true
                }
            }
            else{
                publishEvent()
            }
        }
    }
    
    
    
    func goBack() {
        router.dismissScreen()
    }
    
    func createEventRequestBuilder() -> CreateEventRequest {
        return CreateEventRequest(
            eventName: eventName,
            eventDescription: eventDescription,
            eventStartDate: Int(startDate.timeIntervalSince1970),
            eventEndDate: Int(endDate.timeIntervalSince1970),
            guests: guestsNum,
            authorizeGuests: authorizeGuests,
            contentDurationMonths: nil,
            guestsCanViewGallery: guestsGallery,
            guestsUploadPhoto: true,
            guestsUploadVideo: nil,
            supportStories: true
        )
    }
    
    func saveDraft(){
        var imageData = Data()
        if let eventImageData = eventImage?.jpegData(compressionQuality: 0.8){
            imageData = eventImageData
        }
        draft.eventImage = imageData
        UserDefaultManager.shared.saveData(data: draft, key: .createEventDraft)
    }
    
    func getDraft(){
        if let draft: CreateEventDraft = UserDefaultManager.shared.fetchData(key: .createEventDraft){
            eventImage = UIImage(data: draft.eventImage)
            self.draft = draft
        }
    }
    
//    func convertImageToData(image: Image) -> Data {
//        
//    }
//
//    func navigateToOnboarding(dataService: DataService) {
//        router.showScreen(.push) { router in
//            OnBoardingScreen(router: router, dataService: dataService)
//        }
//    }
    

    
}
