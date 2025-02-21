//
//  BaseViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

@MainActor
protocol BaseViewModel: ObservableObject{
    var isLoading: Bool { get set }
    
    func setLoading()
    func resetLoading()
}
