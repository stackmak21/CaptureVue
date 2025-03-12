//
//  SwipeBackGestures.swift
//  CaptureVue
//
//  Created by Paris Makris on 31/1/25.
//

import Foundation
import SwiftUI
import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    static var isBackEnabled: Bool = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && UINavigationController.isBackEnabled
    }
}



