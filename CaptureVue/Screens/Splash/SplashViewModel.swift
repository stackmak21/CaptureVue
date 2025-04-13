//
//  SplashPresenter.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation
import SwiftfulRouting

@MainActor
class SplashViewModel: ObservableObject{
    
    @KeychainStorage(.token) var token = ""
    @KeychainStorage(.credentials) var credentials = Credentials()
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    
    private let loginUseCase: CredentialsLoginUseCase
    
    
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
        tasks.forEach { $0.cancel() }
    }
    
    func navigateToLogin() {
        router.showScreen(.push) { router in
            LoginScreen(router: router, client: self.client)
        }
    }
    
    func navigateToHome() {
        router.showScreen(.push) { router in
            HomeScreen(router: router, client: self.client)
        }
    }
    
    func navigateToOnBoarding() {
        router.showScreen(.push) { router in
            OnBoardingScreen(router: router, client: self.client)
        }
    }
    
    
    func silentLogin(){
        let task = Task{
            if credentials.isValid() {
                let loginResponse = await loginUseCase.invoke(Credentials(email: credentials.email, password: credentials.password))
                switch loginResponse {
                case .success(let response):
                    token = response.token
                    navigateToHome()
//                    navigateToOnBoarding()
                case .failure(_):
                    navigateToLogin()
                }
            }
            else{
                navigateToLogin()
            }
        }
        tasks.append(task)
    }
    
    
}



