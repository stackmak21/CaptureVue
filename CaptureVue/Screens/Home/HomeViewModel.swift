//
//  HomeViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation
import SwiftfulRouting

@MainActor
class HomeViewModel: ObservableObject {
   
    private let router: AnyRouter
    private let interactor: HomeInteractor
    private var tasks: [Task<Void, Error>] = []
    
    @Published var isLoading: Bool = false
    @Published var events: [EventDto] = []
    
    @KeychainStorage("server_token") var token = ""
    
    init(
        router: AnyRouter,
        interactor: HomeInteractor
    ) {
        self.router = router
        self.interactor = interactor
        fetchEvents()
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    
    
    func fetchEvents() {
        let task = Task{
            do{
                isLoading = true
                let fetcedEvents = try await interactor.fetchEvents(token: token)
                if let events = fetcedEvents{
                    self.events = events
                }
                isLoading = false
            }
            catch let error as CaptureVueError{
                isLoading = false
                Banner(router: router, message: error.msg ?? "", bannerType: .error, bannerDuration: .long, action: nil)
            }
            
        }
        tasks.append(task)
    }
    
    func goToHome() {
        router.showScreen(.push){ router in
            OnBoardingScreen(router: router, dataService: self.interactor.dataService)
        }
    }
    
    func goToCreateEvent() {
        router.showScreen(.push){ router in
            CreateEventScreen(router: router, dataService: self.interactor.dataService)
        }
    }
    
    func goToEvent(event: EventDto) {
        router.showScreen(.push){ router in
            EventHomeScreen(router: router, dataService: self.interactor.dataService, event: event)
        }
    }
//
//    func navigateToOnboarding(dataService: DataService) {
//        router.showScreen(.push) { router in
//            OnBoardingScreen(router: router, dataService: dataService)
//        }
//    }
    

    
}
