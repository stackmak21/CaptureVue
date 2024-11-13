//
//  SystemProperties.swift
//  CaptureVue
//
//  Created by Paris Makris on 3/11/24.
//

import Foundation
import UIKit


struct SystemProperties {
    // Indicates if the app is running in debug mode
    let isDebug: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
    
    // OS name
    let os: String = "iOS"
    
    // Platform version (iOS version)
    let platformVersion: String = UIDevice.current.systemVersion
    
    // Device model (e.g., "iPhone 14 Pro")
    let deviceName: String = UIDevice.current.model
    
    // App version name (version string from Info.plist)
    let versionName: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    // App build number (build version from Info.plist)
    let versionNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    
    // Unique device identifier
    let deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
}
