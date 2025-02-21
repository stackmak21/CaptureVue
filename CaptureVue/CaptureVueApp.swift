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
    
    @Environment(\.scenePhase) var scenePhase
    
    let client: NetworkClient = NetworkClient()
    
    init(){
//        configureNavigationBar()
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView { router in
                SplashScreen(router: router, client: client, authRepository: AuthRepository(client: client))
                    
                    .onOpenURL(perform: { url in
                        let string = url.absoluteString
                        print(string)
                    })
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .active {
                            
                        } else if newPhase == .inactive {
                            
                        } else if newPhase == .background {
                            
                        }
                    }
                    .onAppear{
                        NotificationManager.requestPermissions()
                    }
                
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
