//
//  CaptureVueAppClipApp.swift
//  CaptureVueAppClip
//
//  Created by Paris Makris on 13/10/24.
//

import SwiftUI
import SwiftfulRouting
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}


@main
struct CaptureVueAppClipApp: App {
    //     register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
