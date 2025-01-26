//
//  QRCodeScannerScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/11/24.
//

import SwiftUI

struct QRCodeScannerScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private let feed: QrCameraFeed = QrCameraFeed()
    @State var isconnectionEnabled: Bool = false
    @State var qrIconFocus: Bool = false
    @State var rect: CGRect = .zero
    @State var newRect: CGRect = .zero
    @State var image: UIImage? = nil
    @State var manualInput: Bool = false
    @Binding var qrString: String? 
    
    var body: some View {
        ZStack{
            if manualInput {
                VStack{
                    Text("fdfdfd")
                        .onTapGesture {
                            withAnimation(.smooth){
                                manualInput = false
                            }
                        }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.ignoresSafeArea())
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }else{
                CameraView(session: feed.session, isConnectionEnabled: $isconnectionEnabled, qrRect: $rect, completion: { newRect in
//                    
//                    withAnimation(.easeInOut(duration: 2)) {
//                        self.newRect = newRect
//                    }
                })
                .onAppear{
                    startFeed()
                }
                .onDisappear{
                    stopFeed()
                }
                
                .onAppear{
                    feed.cameraManager.getQrFrame { string, rect  in
                        self.qrString = string
                        self.rect = rect
                        stopFeed()
                    }
                }
//                QRCodeIcon()
//                    .frame(width: qrIconFocus ? newRect.width : 200 , height: qrIconFocus ? newRect.height : 200)
//                    .if(qrIconFocus){ view in
//                        view.position(CGPoint(x: newRect.midX , y: newRect.midY ))
//                    }
//                    .if(!qrIconFocus){ view in
//                        view.frame(maxWidth: .infinity, maxHeight: .infinity)
//                    }
//                Button("new screen"){
//                    withAnimation(.smooth){
//                        
//                        manualInput = true
//                    }
//                    
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: qrString) { qrCode in
            if qrCode != nil {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
            
        
    }
    
    private func startFeed(){
        feed.start()
        isconnectionEnabled = true
    }
    
    private func stopFeed(){
        feed.stop()
        isconnectionEnabled = false
    }
}

#Preview {
    QRCodeScannerScreen(qrString: .constant(nil))
}
