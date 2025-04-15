//
//  SplashPresenter.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation
import SwiftfulRouting
import SwiftUI

@MainActor
class SplashViewModel: ObservableObject{
    
    private let router: AnyRouter
    private var tasks: [Task<Void, Never>] = []
    
    private let client: NetworkClient
    private let keychain: KeychainManager = KeychainManager()
    private let loginUseCase: CredentialsLoginUseCase
    
    private var credentials: Credentials = Credentials()
    
    @Published var isLoading: Bool = false
    
    init(
        router: AnyRouter,
        client: NetworkClient,
        authRepositoryMock: AuthRepositoryContract? = nil
    ) {
        self.router = router
        self.client = client
        self.loginUseCase = CredentialsLoginUseCase(client: client, authRepositoryMock: authRepositoryMock)
        keychain.save(UIDevice.current.identifierForVendor?.uuidString ?? "", key: .deviceId)
        if let userCredentials: Credentials = keychain.getData(key: .credentials){
            credentials = userCredentials
        }
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
        let token = keychain.get(key: .token) ?? ""
        let task = Task{
            if !token.isEmpty {
//                let loginResponse = await loginUseCase.invoke(Credentials(email: credentials.email, password: credentials.password))
//                switch loginResponse {
//                case .success(let response):
//                    keychain.save(response.token, key: .token)
//                    keychain.save(response.refreshAccessToken, key: .refreshToken)
                    navigateToHome()
//                    navigateToOnBoarding()
//                case .failure(_):
//                    navigateToLogin()
                }
            else{
                navigateToLogin()
            }
        }
        tasks.append(task)
    }
    
    
}



