//
//  SwipeBackModifier.swift
//  CaptureVue
//
//  Created by Paris Makris on 3/3/25.
//

import Foundation
import SwiftUI


struct SwipeBackModifier: ViewModifier {
    var isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear{ UINavigationController.isBackEnabled = isEnabled }
            .onDisappear{ UINavigationController.isBackEnabled = true }
    }
}


extension View{
    func allowSwipeBack(_ isEnabled: Bool) -> some View {
        self.modifier(SwipeBackModifier(isEnabled: isEnabled))
    }
}
