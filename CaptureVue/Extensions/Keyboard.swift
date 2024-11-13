//
//  Keyboard.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/11/24.
//


import UIKit

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}