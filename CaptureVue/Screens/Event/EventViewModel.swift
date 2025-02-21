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


@MainActor
class EventViewModel: BaseViewModel {
    
    @KeychainStorage(.token) var token = ""
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    private let fetchEventUseCase: FetchEventUseCase
    
    let eventId: String
    var videoUrl: String = ""

    @Published var event: Event = Event()
    @Published var isLoading: Bool = false
    
    
    init(
        router: AnyRouter,
        client: NetworkClient,
        eventRepositoryMock: EventRepositoryContract? = nil,
        eventId: String
    ) {
        self.router = router
        self.client = client
        self.eventId = eventId
        self.fetchEventUseCase = FetchEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func fetchEvent() {
        let task = Task{
            setLoading()
            defer { resetLoading() }
            let response = await fetchEventUseCase.invoke(eventId, token)
            switch response {
            case .success(let fetchedEvent):
                self.event = fetchedEvent
            case .failure(let error):
                Banner(router: router, message: error.msg , bannerType: .error, bannerDuration: .long, action: nil)
            }
        }
        tasks.append(task)
    }
    
//    
//    private func setLoading(){
//        isLoading = true
//    }
//    
//    private func resetLoading(){
//        isLoading = false
//    }
    
    

}



enum AssetSectionType: String {
    case story
    case gallery
}





