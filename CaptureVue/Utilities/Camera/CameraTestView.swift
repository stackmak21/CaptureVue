//
//  CameraTestView.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/3/25.
//

import Foundation
import SwiftUI

struct CameraTestView: View {
    
    private let feed: CaptureCameraFeed = CaptureCameraFeed()
    
    @State var isconnectionEnabled: Bool = false
    @State var isCameraVisible: Bool = true
    
    var body: some View{
        ZStack{
            LinearGradient(colors: [.black, .black.opacity(0.7)], startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()
            VStack{
                GeometryReader{ proxy in
                    ZStack{
                        ZStack{
                            CameraView(session: feed.session, isConnectionEnabled: $isconnectionEnabled )
                                .onAppear{
                                    startFeed()
                                }
                                .onDisappear{
                                    stopFeed()
                                }
                            HStack{
                                Button(action: {feed.setFlashLightEnabled(enabled: true)}, label: {Text("Flashligth")})
                                Button(action: {feed.onCameraSelect(position: .front)}, label: {Text("Front")})
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        }
                        .frame(height: proxy.size.height)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .ignoresSafeArea(.all, edges: [.top])
                        
                        HStack{
                            ZStack{
                                Button(
                                    action: {},
                                    label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 16)
                                            .foregroundStyle(Color.white)
                                            .font(Typography.medium(size: 16))
                                    })
                                .buttonStyle(PlainButtonStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Capture Vue Camera")
                                    .foregroundStyle(Color.white)
                                    .font(Typography.medium(size: 16))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal)
                    }
                    
                    CameraCaptureButton(onClick: {})
                        .frame(width: 60)
                }
                .background(Color.blue)
            }
            .background(Color.yellow)
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


#Preview{
    CameraTestView()
}
