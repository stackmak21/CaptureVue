//
//  LoginViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import Foundation
import SwiftfulRouting

@MainActor
class LoginViewModel: BaseViewModel {
    
    @KeychainStorage(.token) var token = ""
    @KeychainStorage(.credentials) var credentials = Credentials()
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    
    private let loginUseCase: CredentialsLoginUseCase
    
    @Published var email: String = "test3@gmail.com"
    @Published var password: String = "pass1234"
    @Published var isLoading: Bool = false
    
    
    
    init(
        router: AnyRouter,
        client: NetworkClient,
        authRepositoryMock: AuthRepositoryContract? = nil
    ) {
        self.router = router
        self.client = client
        self.loginUseCase = CredentialsLoginUseCase(client: client, authRepositoryMock: authRepositoryMock)
        
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func onSubmitClicked() {
        let task = Task{
            setLoading()
            defer{ resetLoading() }
            let userCredentials = Credentials(email: email, password: password)
            if userCredentials.isValid(){
                let loginResponse = await loginUseCase.invoke(userCredentials)
                switch loginResponse {
                case .success(let response):
                    print(response.token)
                    token = response.token
                    credentials = userCredentials
                    goToHome()
                case .failure(let error):
                    Banner(router: router, message: error.msg, bannerType: .error, bannerDuration: .long, action: nil)
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
    
    func navigateToOnboarding(client: NetworkClient) {
//        router.showScreen(.push) { router in
//            HomeScreen(router: router, dataService: client)
//        }
    }
    
    
    
}
