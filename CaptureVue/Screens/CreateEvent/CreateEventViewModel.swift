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
class CreateEventViewModel: ObservableObject {
   
    private let router: AnyRouter
    private let interactor: CreateEventInteractor
    private var tasks: [Task<Void, Error>] = []
    
    @Published var isLoading: Bool = false
    
    @Published var eventName: String = "paris birthday SWIFT"
    @Published var eventImage: Image?
    @Published var eventDescription: String = ""
    @Published var authorizeGuests: Bool = false
    @Published var guestsGallery: Bool = false
    @Published var guestsNum: Int = 0
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    
    
    
    @KeychainStorage("server_token") var token = ""
    
    init(
        router: AnyRouter,
        interactor: CreateEventInteractor
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    
    
    func publishEvent() {
        let task = Task{
            do{
                let mainImage = UIImage(systemName: "square.and.arrow.up")?.jpegData(compressionQuality: 0.8)!
                isLoading = true
                let createEventResponse = try await interactor.uploadPhoto(token: token, request: createEventRequestBuilder(), imageData: mainImage)
                
                isLoading = false
                if createEventResponse?.success ?? false{
                    Banner(router: router, message: createEventResponse?.msg ?? "", bannerType: .warning, bannerDuration: .long, action: nil)
                }
            }
            catch let error as CaptureVueError{
                isLoading = false
                Banner(router: router, message: error.msg ?? "", bannerType: .error, bannerDuration: .long, action: nil)
            }
            
        }
        tasks.append(task)
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
            guestsUploadVideo: nil
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
