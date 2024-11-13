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
    let dataService: DataService
    
    init(router: AnyRouter, dataService: DataService) {
        self.dataService = dataService
        let interactor = SplashInteractor(dataService: dataService)
        _viewModel = StateObject(wrappedValue: SplashViewModel(router: router, interactor: interactor))
    }
    
    var body: some View {
        VStack{
            Text(Strings.helloWorld)
          
           
            Button("Go To On Boarding", action: {
                viewModel.navigateToOnboarding(dataService: dataService)
            })
            .buttonStyle(PrimaryButtonStyle())
         
          

        }
    }
}

#Preview {
    let dataService = DataServiceImpl()
    
    RouterView{ router in
        SplashScreen(router: router, dataService: dataService)
    }
}



