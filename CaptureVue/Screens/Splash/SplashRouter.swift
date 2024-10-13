//
//  SplashRouter.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation
import SwiftfulRouting
import SwiftUI

protocol SplashRouter{
    var router: AnyRouter { get }
    func goToContent() -> Void
    func goToContent1() -> Void
    func goToContent2() -> Void
    func goToContent3() -> Void
    @available(iOS 16.0, *)
    func goToContent4(_ data: String) -> Void
    func goToContent5(_ data: String) -> Void
}

class SplashRouter_Production: SplashRouter{

    
    let router: AnyRouter
    
    init(router: AnyRouter) {
        self.router = router
    }
    
    func goToContent1() -> Void {
        router.showScreen(AnyRoute(.push, destination: {ContentView(router: $0)}))
    }
    
    func goToContent2() -> Void {
        router.showScreen(AnyRoute(.fullScreenCover, destination: {ContentView(router: $0)}))
    }
    
    func goToContent3() -> Void {
        router.showScreen(AnyRoute(.sheet, destination: {ContentView(router: $0)}))
    }
    
    @available(iOS 16.0, *)
    func goToContent4(_ data: String) -> Void {
        router.showScreen(AnyRoute(.sheetDetents, destination: {ContentView(router: $0, data: data)}))
    }
    
    func goToContent5(_ data: String) {
        router.showModal(transition: .move(edge: .leading), animation: .easeInOut, alignment: .leading, backgroundColor: .black.opacity(0.35), dismissOnBackgroundTap: true, ignoreSafeArea: true, destination: {Text(data).frame(maxHeight: .infinity).frame(width: 200).background(Color.blue).multilineTextAlignment(.leading)})
    }
    
    
    
    
    func goToContent() {
        router.showScreen(AnyRoute(.push, destination: {ContentView(router: $0)}))
    }
    
}


class SplashRouter_Mock: SplashRouter{
    func goToContent5(_ data: String) {
        
    }
    
    func goToContent1() {
            
    }
    
    func goToContent2() {
        
    }
    
    func goToContent3() {
        
    }
    
    func goToContent4(_ data: String) {
        
    }
    
    let router: AnyRouter
    
    init(router: SwiftfulRouting.AnyRouter) {
        self.router = router
    }
    func goToContent() {
        
    }
    
    
}

extension SplashRouter{
    func goToSplash() -> Void {
        
    }
}
