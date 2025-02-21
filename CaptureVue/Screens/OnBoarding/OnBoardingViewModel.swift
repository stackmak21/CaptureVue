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
    
    @KeychainStorage(.token) var token = ""
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private let client: NetworkClient
    private let validateEventUseCase: ValidateEventUseCase
    private let fetchEventUseCase: FetchEventUseCase
    
    @Published var eventId: String?

    init(
        router: AnyRouter,
        client: NetworkClient,
        eventRepositoryMock: EventRepositoryContract? = nil
    ) {
        self.router = router
        self.client = client
        self.validateEventUseCase = ValidateEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
        self.fetchEventUseCase = FetchEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }

    func nextScreen(eventId: String){
        let task = Task{
            let validateResponse =  await validateEventUseCase.invoke(eventId)
            if case .success(let validateResult) = validateResponse{
                if validateResult.isValid{
                    router.showScreen(.push) { router in
                        
                    }
                }
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





