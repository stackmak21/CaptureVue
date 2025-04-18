//
//  HomeViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import Foundation
import Combine
import SwiftfulRouting

@MainActor
class HomeViewModel: BaseViewModel {
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    private var cancellables =  Set<AnyCancellable>()
    
    private let client: NetworkClient
    private let keychain: KeychainManager = KeychainManager()
    
    //MARK: - Use Cases
    private let fetchCustomerHomeUseCase: FetchCustomerHomeUseCase
    
    
    //MARK: - Screen State
    @Published var isLoading: Bool = false
    @Published var customer: Customer = Customer()
    @Published var hostEvents: [Event] = []
    @Published var participatingEvents: [Event] = []
    
    //MARK: - Constructor
    init(
        router: AnyRouter,
        client: NetworkClient,
        customerRepositoryMock: CustomerRepositoryContract? = nil
    ) {
        self.router = router
        self.client = client
        self.fetchCustomerHomeUseCase = FetchCustomerHomeUseCase(client: client, customerRepositoryMock: customerRepositoryMock)
    }
    
    deinit {
        tasks.forEach{ $0.cancel() }
    }
    
    func logoutUser(){
        keychain.saveData(Credentials(), key: .credentials)
        keychain.save("", key: .token)
        keychain.save("", key: .refreshToken)
        keychain.saveData(Customer(), key: .customer)
        goToLogin()
    }
    
}


//MARK: - Networking
extension HomeViewModel {
    
    func fetchEvents() {
        let task = Task{
            setLoading()
            defer{resetLoading()}
            switch await fetchCustomerHomeUseCase.invoke(){
            case .success(let response):
                customer = response.customer
                hostEvents = response.hostEvents
                participatingEvents = response.participatingEvents
            case .failure(let error):
                Banner(router: router, message: error.msg ?? "" , bannerType: .error, bannerDuration: .long, action: nil)
            }
        }
        tasks.append(task)
    }
}


//MARK: - Routing
extension HomeViewModel {
    
    func goToLogin(){
        router.showScreen(.push, destination: { LoginScreen(router: $0, client: self.client) })
    }
    
    func analyzeQrCode(qrCodeString: String) {
        if let qrCodeURL = URL(string: qrCodeString){
            router.showScreen(.push) { router in
                CoverScreen(router: router, client: self.client, eventId: qrCodeURL.lastPathComponent)
            }
            
        }
    }
    
    func goToCreateEvent() {
        router.showScreen(.push){ router in
            CreateEventScreen(router: router, client: self.client)
        }
    }
    
    func goToEvent(eventId: String) {
        router.showScreen(.push){ router in
            EventScreen(router: router, client: self.client, eventId: eventId)
        }
    }
    
    func dismissScreenStack() {
        router.dismissEnvironment()
    }
}


////MARK: - Loading State
//extension HomeViewModel{
//    private func setLoading(){
//        isLoading = true
//    }
//    
//    private func resetLoading(){
//        isLoading = false
//    }
//}
