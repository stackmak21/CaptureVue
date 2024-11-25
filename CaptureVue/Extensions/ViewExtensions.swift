//
//  ViewExtensions.swift
//  CaptureVue
//
//  Created by Paris Makris on 9/11/24.
//

import Foundation
import SwiftUI


extension View{
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
            if condition {
                apply(self)
            } else {
                self
            }
        }
}


