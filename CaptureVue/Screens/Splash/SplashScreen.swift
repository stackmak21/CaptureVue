//
//  SplashScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import SwiftUI
import SwiftfulRouting

struct SplashScreen: View {
    
    @StateObject var viewModel: SplashViewModel
    
    init(router: AnyRouter, client: NetworkClient, authRepository: AuthRepositoryContract) {
        _viewModel = StateObject(wrappedValue: SplashViewModel(router: router, client: client, authRepository: authRepository))
    }
    
    var body: some View {
        VStack{
            Text(Strings.helloWorld)
          
           
            Button("Go To On Boarding", action: {
                viewModel.navigateToLogin()
            })
            .buttonStyle(PrimaryButtonStyle())
        
        }
        .onAppear(perform: viewModel.silentLogin)
    }
}

#Preview {
    RouterView{ router in
        SplashScreen(router: router, client: NetworkClient(), authRepository: AuthRepositoryMock())
    }
}



