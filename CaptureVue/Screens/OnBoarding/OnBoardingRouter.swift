//
//  OnBoardingRouter.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/10/24.
//

import Foundation
import SwiftfulRouting
import SwiftUI

protocol OnBoardingRouter {
    var router: AnyRouter { get }
    func openSheetDetents()
    func openBasicModal()
    func showScreenSheetDetents()   
}

class OnBoardingRouter_Production: OnBoardingRouter {


    let router: AnyRouter
    
    init(router: AnyRouter) {
        self.router = router
    }
    
    func openSheetDetents() {
        router.showResizableSheet(sheetDetents: [.medium], selection: nil, showDragIndicator: true, destination: {_ in EmptyView()})
    }
    
    func openBasicModal() {
        router.showBasicModal(destination: {QRCodeCapture()})
    }
    
    func showScreenSheetDetents() {
        router.showScreen(.sheetDetents, destination: {_ in QRCodeCapture()})
    }
    
}


class OnBoardingRouterTests {
    
}
