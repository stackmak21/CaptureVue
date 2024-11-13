//
//  PermissionAlertStatus.swift
//  CaptureVue
//
//  Created by Paris Makris on 31/10/24.
//

import Foundation

class PermissionAlertStatus: ObservableObject {
    
    static let shared: PermissionAlertStatus = PermissionAlertStatus()
    
    @Published private(set) var isSystemAlertVisible: Bool
    
    private init() {
        isSystemAlertVisible = false
    }
    
    func setVisible(isVisible: Bool) {
        isSystemAlertVisible = isVisible
    }
    
}
