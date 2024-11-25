//
//  OnBoardingScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/10/24.
//

import Foundation
import SwiftUI
import SwiftfulRouting


struct OnBoardingScreen: View {
    
    @StateObject var viewModel: OnBoardingViewModel
    @State var isPresent: Bool = false
    
   
    
    init(router: AnyRouter, dataService: DataService ) {
        let interactor = OnBoardingInteractor(dataService: dataService)
        _viewModel = StateObject(wrappedValue: OnBoardingViewModel(router: router, interactor: interactor))
    }
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                
                Image(uiImage: Asset.Illustrations.image.image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.black)
                    .frame(width: 100, height: 100)
                    .padding(.top)
             
                
                Spacer()
                Button("Fetch String") {
                    
                }
                .buttonStyle(PrimaryButtonStyle())
                Button("Show Banner") {
                    viewModel.nextScreen(eventId: "cp-12345")
                }
                .buttonStyle(PrimaryButtonStyle())
                Text("Welcome to CaptureVue")
                    .font(Typography.bold(size: 20))
                    .foregroundStyle(Color.black)
                    .padding()
                Group{
                    Button {
                        
                    } label: {
                        Text("Create an event")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button {
                        isPresent = true
                    } label: {
                        Text("Scan QR Code")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.bottom, 100)
                }
                
                

            }
            .padding()
            .sheet(isPresented: $isPresent) {
                QRCodeScannerScreen(qrString: $viewModel.eventId)
                .presentationDetents([.medium])
                .onDisappear() {
                    viewModel.goToEventHome()
                }
            }
        }
       
    }
}

#Preview {
    let dataService = DataServiceImpl()
    RouterView { router in
        OnBoardingScreen(router: router, dataService: dataService)
    }
    
}


struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.medium(size: 16))
            .foregroundStyle(Color.black.opacity(configuration.isPressed ? 0.6 : 1))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.white.opacity(0.001))
            .overlay {
                Capsule().stroke(Color.black.opacity(configuration.isPressed ? 0.6 : 1),style: StrokeStyle(lineWidth: 2))
            }
            
    }
}







