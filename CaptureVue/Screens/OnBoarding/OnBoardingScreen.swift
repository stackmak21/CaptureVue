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
    
    @StateObject var presenter: OnBoardingPresenter
    @State var isPresent: Bool = false
    private let feed: QrCameraFeed = QrCameraFeed()
    @State var isconnectionEnabled: Bool = false
    
    init(router: AnyRouter, dataService: NetworkService ) {
        _presenter = StateObject(wrappedValue: OnBoardingPresenter(router: OnBoardingRouter_Production(router: router), interactor: OnBoardingInteractor_Production(dataService: dataService)))
    }
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea() 
            VStack{
//                Button("Sheet") {
//                    isPresent = true
//                }
//                Button("Sheet") {
//                    presenter.showCaptureImage()
//                }
//                Button("Sheet") {
//                    presenter.showCaptureQRCode()
//                }
                Button("Scan QR Code") {
                    isPresent = true
                }
                .buttonStyle(DefaultButtonStyle())
            }
            .sheet(isPresented: $isPresent) {
                CameraView(session: feed.session, isConnectionEnabled: $isPresent)
                    .ignoresSafeArea()
            }
        }
        .ignoresSafeArea()
        .onChange(of: isPresent) {
            if $0 {
                feed.start()
            }else{
                feed.stop()
            }
        }
    }
}

#Preview {
    let dataService = DataService()
    return RouterView { router in
        OnBoardingScreen(router: router, dataService: dataService)
    }
    
}


struct QRCodeCapture: View {
    
    var body: some View {
        ScrollView{
            VStack{
                        
                        Text("Hello Sheet")
                            .foregroundStyle(.white)
                        Image(systemName: "qrcode")
                            .resizable()
                            .frame(width: 200, height: 200)
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                
        }
        
        .background(Color.blue)
        
    }
    
    }

