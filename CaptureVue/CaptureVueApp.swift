//
//  CaptureVueApp.swift
//  CaptureVue
//
//  Created by Paris Makris on 8/10/24.
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
struct CaptureVueApp: App {
//     register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let networkService: NetworkService = DataService()
    
    var body: some Scene {
        WindowGroup {
            RouterView { router in
                OnBoardingScreen(router: router, dataService: networkService)
                    .onOpenURL(perform: { url in
                        let string = url.absoluteString
                        print(string)
                    })
            }
        }
    }
}
