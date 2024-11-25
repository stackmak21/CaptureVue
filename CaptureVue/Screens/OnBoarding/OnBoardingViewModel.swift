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

    func nextScreen(eventId: String){
        let task = Task{
            do{
                let validateResult =  try await interactor.validateEvent(eventId: eventId)
                
                if let  result = validateResult{
                    if result.isValid{
                        let event = try await interactor.fetchEvent(eventId: eventId)
                        if let fetchedEvent = event{
                            router.showScreen(.push) { router in
                                EventHomeScreen(router: router, dataService: self.interactor.dataService, event: fetchedEvent)
                            }
                        }
                    }
                    
                }
            }
            catch let error as CaptureVueError{
                banner(message: error.msg ?? "", bannerType: .error, bannerDuration: .infinite, action: nil)
            }
        }
        tasks.append(task)
    }
    
    func goToEventHome(){
        if let eventId {
             fetchEvent(eventId: eventId)
        }
    }
    
    private func fetchEvent(eventId: String){
        let task = Task{
            do{
                let validateResult =  try await interactor.validateEvent(eventId: eventId)
                if let  result = validateResult{
                    if result.isValid{
                        let event = try await interactor.fetchEvent(eventId: eventId)
                        if let fetchedEvent = event{
                            router.showScreen(.push) { router in
                                EventHomeScreen(router: router, dataService: self.interactor.dataService, event: fetchedEvent)
                            }
                        }
                    }
                    
                }
            }
            catch let error as CaptureVueError{
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





