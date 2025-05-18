//
//  HomeViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation
import SwiftfulRouting
import SwiftUI


@MainActor
class CreateEventViewModel: BaseViewModel {
   
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    // Use Cases
    private let createEventUseCase: CreateEventUseCase
    
    
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
    
    
    

    
    init(
        router: AnyRouter,
        client: NetworkClient,
        eventRepositoryMock: EventRepositoryContract? = nil
    ) {
        self.router = router
        self.client = client
        self.createEventUseCase = CreateEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func startUpload(fileUrl: URL) {
//        mux.uploadVideoToMux(fileURL: fileUrl)
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
        
//        let task = Task{
//            do{
//                let mainImage = UIImage(systemName: "square.and.arrow.up")?.jpegData(compressionQuality: 0.8)!
//                let secondImage = eventImage?.jpegData(compressionQuality: 0.1)
//                isLoading = true
//                
//                
//                isLoading = false
//                
//                    
//                
//            }
//            catch let error as CaptureVueErrorDto{
//                isLoading = false
//
//            }
//            
//        }
//        tasks.append(task)
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
