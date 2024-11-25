//
//  CaptureVueApp.swift
//  CaptureVue
//
//  Created by Paris Makris on 8/10/24.
//

import SwiftUI
import SwiftfulRouting
import Firebase

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}

@main
struct CaptureVueApp: App {
//     register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let dataService: DataService = DataServiceImpl()
    
    var body: some Scene {
        WindowGroup {
//            RouterView { router in
//                SplashScreen(router: router, dataService: dataService)
//                    .onOpenURL(perform: { url in
//                        let string = url.absoluteString
//                        print(string)
//                    })
//            }
//            TestTabViewOpening()
            let dev = DeveloperPreview.instance
            let dataService = DataServiceImpl()
            RouterView{ router in
                EventHomeScreen(router: router, dataService: dataService, event: dev.event)
            }
           
        }
    }
}
