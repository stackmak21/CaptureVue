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
    
    let dataService: DataService
    
    init(){
        self.dataService = DataServiceImpl()
//        configureNavigationBar()
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView { router in
                SplashScreen(router: router, dataService: dataService)
                    .onOpenURL(perform: { url in
                        let string = url.absoluteString
                        print(string)
                    })
//                LoginScreen(router: router, dataService: dataService)
//                EventHomeScreen(router: router, dataService: dataService, event: DeveloperPreview.instance.event)
            }
//            TestTabViewOpening()
//            let dev = DeveloperPreview.instance
//            let dataService = DataServiceImpl()
//            RouterView{ router in
//                EventHomeScreen(router: router, dataService: dataService, event: dev.event)
////                LoginScreen(router: router, dataService: dataService)
//            }
            
           
        }
    }
//    
//    private func configureNavigationBar() {
//        let backgroundColor = UIColor(Color.blue)
//        let foregroundColor = UIColor(Color.white)
//        
//        let coloredAppearance = UINavigationBarAppearance()
//        coloredAppearance.configureWithOpaqueBackground()
//        coloredAppearance.backgroundColor = backgroundColor
//        coloredAppearance.titleTextAttributes = [.foregroundColor: foregroundColor]
//        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
//        
//        UINavigationBar.appearance().standardAppearance = coloredAppearance
//        UINavigationBar.appearance().compactAppearance = coloredAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
//        UINavigationBar.appearance().tintColor = foregroundColor
//    }
}
