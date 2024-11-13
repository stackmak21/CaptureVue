//
//  OnBoardingViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/10/24.
//

import Foundation
import SwiftfulRouting
import SwiftUI
import Combine

@MainActor
class OnBoardingViewModel: ObservableObject {
    
    private let router: AnyRouter
    private let interactor: OnBoardingInteractor
    private var tasks: [Task<Void, Error>] = []
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var eventId: String?

    init(
        router: AnyRouter,
        interactor: OnBoardingInteractor
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }

    func nextScreen(){
//        router.showScreen(.push, destination: {router in Text("Hello")})
        banner(message: "No Capture Vue Error", bannerType: .error, bannerDuration: .long, action: nil)
        
    }
    
    func goToEventHome(){
        if let eventId {
             validateEvent(eventId: eventId)
        }
    }
    
    private func validateEvent(eventId: String){
        let task = Task{
            do{
                let validateResult =  try await interactor.validateEvent(eventId: eventId)
                if let  result = validateResult{
                    router.showScreen(.push) { router in
                        Text(result.hasExpired ? "Event Expired" : "Event Started")
                    }
                }
            }
            catch let error as CaptureVueErrorDto{
                banner(message: error.msg ?? "", bannerType: .error, bannerDuration: .infinite, action: nil)
            }
        }
        tasks.append(task)
    }
    
}

extension OnBoardingViewModel {
    private func banner(
        message: String,
        bannerType: BannerType,
        bannerDuration: BannerDuration,
        action: BannerAction?
    ){
        router.showModal(
            transition: .move(edge: .bottom),
            animation: .easeInOut,
            alignment: .bottom,
            backgroundColor: .black.opacity(0.1),
            dismissOnBackgroundTap: true,
            ignoreSafeArea: false,
            destination: {
                Banner(router: self.router, message: message, bannerType: bannerType, bannerDuration: bannerDuration, action: action)
            })
    }
}


struct OnBoardingRoutes{
    static func goToEventHome(router: AnyRouter, eventId: String) -> AnyRoute{
        AnyRoute(.push) { router in
            ContentView(router: router)
        }
    }
}



