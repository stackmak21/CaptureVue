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
    private var tasks: [Task<Void, Error>] = []
    
    private let client: NetworkClient
    
    
    @Published var isLoading: Bool = false
    
    @Published var eventName: String = "paris birthday SWIFT"
    @Published var eventImage: UIImage?
    @Published var eventDescription: String = ""
    @Published var authorizeGuests: Bool = false
    @Published var guestsGallery: Bool = false
    @Published var guestsNum: Int = 0
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    
    @Published var videoURL: URL?
    
    
    
    @KeychainStorage(.token) var token = ""
    
    init(
        router: AnyRouter,
        client: NetworkClient
    ) {
        self.router = router
        self.client = client
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func startUpload(fileUrl: URL) {
//        mux.uploadVideoToMux(fileURL: fileUrl)
    }
    
    
    
    func publishEvent() {
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
//                Banner(router: router, message: error.msg ?? "", bannerType: .error, bannerDuration: .long, action: nil)
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
