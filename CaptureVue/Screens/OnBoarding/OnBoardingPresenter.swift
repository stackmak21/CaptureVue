//
//  OnBoardingPresenter.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/10/24.
//

import Foundation
import SwiftfulRouting

@MainActor
class OnBoardingPresenter: ObservableObject {
    
    private let router: OnBoardingRouter
    private let interactor: OnBoardingInteractor
    private var tasks: [Task<Void, Never>] = []
    
    init(
        router: OnBoardingRouter,
        interactor: OnBoardingInteractor
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    func showCaptureQRCode() {
        router.openBasicModal()
    }
    
    func showCaptureImage() {
        router.openSheetDetents()
    }
    
    func showCaptureVideo() {
        router.showScreenSheetDetents()
        
    }
    
    
    
}
