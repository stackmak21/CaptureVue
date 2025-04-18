//
//  QRCodeScannerScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/11/24.
//

import SwiftUI

struct QRCodeScannerScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private let feed: QRCameraFeed = QRCameraFeed()
    @State var isconnectionEnabled: Bool = false
    @State var qrIconFocus: Bool = false
    @State var rect: CGRect = .zero
    @State var newRect: CGRect = .zero
    @State var image: UIImage? = nil
    @State var manualInput: Bool = false
    @State var qrImage: UIImage?
    @State var qrCode: String = ""
    let onQrString: (String) -> Void
    
    @Namespace private var namespace
    
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
                GeometryReader{ proxy in
                    QRCameraView(session: feed.session, isConnectionEnabled: $isconnectionEnabled, qrRect: $rect, completion: { newRect in
                        
//                                            withAnimation(.easeInOut(duration: 2)) {
                        DispatchQueue.main.async {
                            if !qrIconFocus, rect != .zero && self.newRect != newRect{
                                self.newRect = newRect
                                withAnimation {
                                    qrIconFocus = true
                                }completion: {
                                    print("Animation completion called")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                        stopFeed()
                                        self.newRect = .zero
                                        onQrString(qrCode)
                                        presentationMode.wrappedValue.dismiss()
                                        
                                    }
                                }
                            }
                        }
                                               
//                                            }
                    })
                    .overlay(content: {
                        ZStack{
                            if let image = qrImage{
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                            }
                            if qrIconFocus{
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(lineWidth: 5)
//                                    .fill(Color.red)
//                                Image(uiImage: Asset.Illustrations.image.image)
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .matchedGeometryEffect(id: "qr_placholder", in: namespace)
//                                    .foregroundStyle(Color.black)
                                QRCodeIcon(color: .black)
                                    .matchedGeometryEffect(id: "qr_placholder", in: namespace)
                                    .frame(width: newRect.width , height: newRect.height)
                                    .position(CGPoint(x: newRect.midX , y: newRect.midY ))
                            }
                            
                            if !qrIconFocus{
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(lineWidth: 5)
//                                    .fill(Color.red)
//                                Image(uiImage: Asset.Illustrations.image.image)
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .matchedGeometryEffect(id: "qr_placholder", in: namespace)
//                                    .foregroundStyle(Color.black)
                                QRCodeIcon(color: .black)
                                    .matchedGeometryEffect(id: "qr_placholder", in: namespace)
                                    .frame(width: 200, height: 200)
                                
//                                    .if(qrIconFocus){ view in
//                                        view.position(CGPoint(x: newRect.midX , y: newRect.midY  ))
//                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                //                                .if(!qrIconFocus){ view in
                                //                                    view.frame(maxWidth: .infinity, maxHeight: .infinity)
                                //                                }
                            }
                        }
                    })
                    .onAppear{
                        startFeed()
                    }
                    .onDisappear{
                        stopFeed()
                        qrIconFocus = false
                    }
                    
                    .onAppear{
                        feed.cameraManager.getQrFrame { QrCodeString, rect  in
                            self.rect = rect
                            self.qrCode = QrCodeString
                        }
                        feed.cameraManager.getImage { image in
                            qrImage = image
                        }
                    }
                   
//                    Button("new screen"){
//                        withAnimation(.smooth){
//                            
//                            qrIconFocus.toggle()
//                        }
//                        
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: newRect) { oldValue, newValue in
            
        }
//        .onChange(of: qrString) { qrCode in
//            if qrCode != nil {
//
//            }
//        }
        
            
        
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
    QRCodeScannerScreen(onQrString: {qrString in })
}
