//
//  RegisterViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import Foundation
import SwiftfulRouting

@MainActor
class RegisterViewModel: BaseViewModel {
    
    let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    private let keychain: KeychainManager = KeychainManager()
    
    private let registerUseCase: RegisterUserUseCase
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    
    
    
    init(
        router: AnyRouter,
        client: NetworkClient,
        authRepositoryMock: AuthRepositoryContract? = nil
    ) {
        self.router = router
        self.client = client
        self.registerUseCase = RegisterUserUseCase(client: client, authRepositoryMock: authRepositoryMock)
        
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func onSubmitClicked() {
        let task = Task{
            setLoading()
            defer{ resetLoading() }
            let registerDetails = RegisterDetails(firstName: firstName, lastName: lastName, email: email, password: password)
            if registerDetails.isValid(){
                let registerResponse = await registerUseCase.invoke(registerDetails)
                switch registerResponse {
                case .success(let response):
                    keychain.save(response.token, key: .token)
                    keychain.save(response.refreshAccessToken, key: .refreshToken)
                    keychain.saveData(response.customer, key: .customer)
                    goToHome()
                case .failure(let error):
                    Banner(message: error.msg ?? "", bannerType: .error, bannerDuration: .long, action: nil)
                }
            }
        }
        tasks.append(task)
    }
    
    private func goToHome() {
        router.showScreen(.push){ router in
            HomeScreen(router: router, client: self.client)
        }
    }
    
    func goToLoginScreen() {
        router.showScreen(.push){ router in
            LoginScreen(router: router, client: self.client)
        }
    }
    
    func navigateToOnboarding(client: NetworkClient) {
//        router.showScreen(.push) { router in
//            HomeScreen(router: router, dataService: client)
//        }
    }
    
    
    
}
