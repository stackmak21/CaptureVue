//
//  BaseViewModelExtension.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

extension BaseViewModel {
    
    func setLoading(){
        isLoading = true
    }
    
    func resetLoading(){
        isLoading = false
    }
}

