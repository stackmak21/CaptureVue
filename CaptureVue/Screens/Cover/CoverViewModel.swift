//
//  CoverViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 16/4/25.
//

import Foundation
import SwiftfulRouting


class CoverViewModel: BaseViewModel{
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    private let keychain: KeychainManager = KeychainManager()
    private let fetchEventUseCase: FetchEventUseCase
    private let guestLoginUseCase: GuestLoginUseCase
    private let fetchEventCoverUseCase: FetchEventCoverUseCase
    
    
    let eventId: String
    
    @Published var event: EventCover = EventCover()
    
    @Published var isLoading: Bool = false
    
    init(
        router: AnyRouter,
        client: NetworkClient,
        eventId: String,
        eventRepositoryMock: EventRepositoryContract? = nil,
        authRepositoryMock: AuthRepositoryMock? = nil
    ) {
        self.router = router
        self.client = client
        self.eventId = eventId
        self.fetchEventUseCase = FetchEventUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
        self.guestLoginUseCase = GuestLoginUseCase(client: client, authRepositoryMock: authRepositoryMock)
        self.fetchEventCoverUseCase = FetchEventCoverUseCase(client: client, eventRepositoryMock: eventRepositoryMock)
    }
    
    
    
    func handleUserAuthentication(){
        let token = keychain.get(key: .token) ?? ""
        if !token.isEmpty{
            fetchEventCover()
        }
        else{
            Task{
                let result = await guestLoginUseCase.invoke()
                switch result {
                case .success(let response):
                    keychain.save(response.token, key: .token)
                    keychain.save(response.refreshAccessToken, key: .refreshToken)
                    keychain.saveData(response.customer, key: .customer)
                    fetchEventCover()
                case .failure(let failure):
                    log.error(failure.localizedDescription)
                }
            }
        }
        
    }
    
    func fetchEventCover(){
            let task = Task{
                setLoading()
                defer { resetLoading() }
                let response = await fetchEventCoverUseCase.invoke(eventId)
                switch response {
                case .success(let fetchedEvent):
                    self.event = fetchedEvent
                    showBanner(message: "Success Event Cover", .info)
                case .failure(let error):
                    showBanner(message: error.msg ?? "empty message")
                }
            }

        tasks.append(task)
    }
    
    private func showBanner(message: String, _ bannerType: BannerType = .error, _ bannerDuration: BannerDuration = .long, action: BannerAction? = nil) {
        router.showModal(
            transition: .move(edge: .bottom),
            animation: .easeInOut,
            alignment: .bottom,
            backgroundColor: .black.opacity(0.1),
            dismissOnBackgroundTap: true,
            ignoreSafeArea: false,
            destination: { Banner(message: message, bannerType: bannerType, bannerDuration: bannerDuration, action: action) }
        )
    }
    
    func goToEvent(){
        router.showScreen(.push) { router in
            EventScreen(router: router, client: self.client, eventId: self.eventId)
        }
    }
    
    
    
}
