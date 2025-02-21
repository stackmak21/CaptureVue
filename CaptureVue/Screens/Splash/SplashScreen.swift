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
    
    init(router: AnyRouter, client: NetworkClient, authRepositoryMock: AuthRepositoryContract? = nil) {
        _viewModel = StateObject(wrappedValue: SplashViewModel(router: router, client: client, authRepositoryMock: authRepositoryMock))
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
        SplashScreen(router: router, client: NetworkClient(), authRepositoryMock: AuthRepositoryMock())
    }
}



