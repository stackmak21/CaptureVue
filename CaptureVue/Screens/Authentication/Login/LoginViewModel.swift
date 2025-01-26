//
//  LoginViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import Foundation
import SwiftfulRouting

@MainActor
class LoginViewModel: ObservableObject {
   
    private let router: AnyRouter
    private let interactor: LoginInteractor
    private var tasks: [Task<Void, Error>] = []
    
    @Published var email: String = "test1@gmail.com"
    @Published var password: String = "pass1234"
    @Published var isLoading: Bool = false
    
    @KeychainStorage("server_token") var token = ""
    
    init(
        router: AnyRouter,
        interactor: LoginInteractor
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }
    
    func onSubmitClicked() {
        let task = Task{
            do{
                isLoading = true
                let loginResponse = try await interactor.authenticateUser(credentials: Credentials(email: email, password: password))
                if let tokenString = loginResponse?.token{
                    token = tokenString
                }
                isLoading = false
                navigateToOnboarding(dataService: interactor.dataService)
                
            }
            catch let error as CaptureVueError{
                isLoading = false
                Banner(router: router, message: error.msg ?? "", bannerType: .error, bannerDuration: .long, action: nil)
            }
            
        }
        tasks.append(task)
    }
    
    private func goToHome() {
        router.showScreen(.push){ router in
            
        }
    }
    
    func navigateToOnboarding(dataService: DataService) {
        router.showScreen(.push) { router in
            HomeScreen(router: router, dataService: self.interactor.dataService)
        }
    }
    

    
}
