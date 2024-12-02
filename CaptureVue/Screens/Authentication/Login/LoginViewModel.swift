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
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    init(
        router: AnyRouter,
        interactor: LoginInteractor
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    func onLoginClicked() {
        
    }
    
}
