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
    
    @Published var isLoading: Bool = false
    
    private let router: AnyRouter
    private let interactor: SplashInteractor
    private var tasks: [Task<Void, Never>] = []
    
    init(
        router: AnyRouter,
        interactor: SplashInteractor
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        tasks.forEach { $0.cancel() }
    }
    
    func navigateToOnboarding(dataService: DataService) {
        router.showScreen(.push) { router in
            OnBoardingScreen(router: router, dataService: dataService)
        }
    }
    
    
    
}



