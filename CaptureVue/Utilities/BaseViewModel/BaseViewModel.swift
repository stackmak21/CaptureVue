//
//  BaseViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation
import SwiftfulRouting

@MainActor
protocol BaseViewModel: ObservableObject{
    
    
    var isLoading: Bool { get set }
    var router: AnyRouter { get }
    
    func setLoading()
    func resetLoading()
}
