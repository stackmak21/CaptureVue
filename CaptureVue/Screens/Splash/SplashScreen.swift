//
//  SplashScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import SwiftUI
import SwiftfulRouting

struct SplashScreen: View {
    
    @StateObject var presenter: SplashPresenter
    
    init(router: AnyRouter) {
        _presenter = StateObject(wrappedValue: SplashPresenter(router: SplashRouter_Production(router: router), interactor: SplashInteractor_Production(dataService: DataService())))
    }
    
    var body: some View {
        VStack{
            Text(Strings.helloWorld)
            Button("Push to Content1", action: {presenter.goToContent1()})
            Button("fullscreen", action: {presenter.goToContent2()})
            Button("Sheet", action: {presenter.goToContent3()})
            Button("Sheet Detention", action: {
                if #available(iOS 16.0, *) {
                    presenter.goToContent4()
                }
            })
            Button("Fatal Error 1234", action: {
                fatalError("Paris Triggered this error")
            })
            Button("Modal", action: {
                if #available(iOS 16.0, *) {
                    presenter.goToContent5()
                }
            })
          

        }
    }
}

#Preview {
    RouterView{ router in
        SplashScreen(router: router)
    }
}



