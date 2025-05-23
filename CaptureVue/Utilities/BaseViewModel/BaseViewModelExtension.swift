//
//  BaseViewModelExtension.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation
import SwiftfulRouting

extension BaseViewModel {
    
    func setLoading(){
        isLoading = true
    }
    
    func resetLoading(){
        isLoading = false
    }
    
    func showBanner(message: String, bannerType: BannerType = .error, bannerDuration: BannerDuration = .short, action: BannerAction? = nil) {
        router.showModal(
            transition: .move(edge: .bottom),
            animation: .easeInOut,
            alignment: .bottom,
            backgroundColor: .black.opacity(0.1),
            dismissOnBackgroundTap: true,
            ignoreSafeArea: false,
            destination: { Banner(message: message, bannerType: bannerType, bannerDuration: bannerDuration, action: action, onDismiss: { self.router.dismissModal()}) }
        )
    }
}

