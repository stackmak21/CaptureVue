//
//  SplashPresenter.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation
import SwiftfulRouting

@MainActor
class SplashPresenter: ObservableObject{
    
    @Published var isLoading: Bool = false
    
    private let router: SplashRouter
    private let interactor: SplashInteractor
    private var tasks: [Task<Void, Never>] = []
    
    init(
        router: SplashRouter,
        interactor: SplashInteractor
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        tasks.forEach { $0.cancel() }
    }
    
    func goToContent1(){
        router.goToContent1()
    }
    
    func goToContent2(){
        router.goToContent2()
    }
    
    func goToContent3(){
        router.goToContent3()
    }
    @available(iOS 16.0, *)
    func goToContent4(){
        router.goToContent4("Hello From Splash Screen")
    }
    
    @available(iOS 16.0, *)
    func goToContent5(){
        router.goToContent5("Hello From Splash Screen")
    }
    
    
}



