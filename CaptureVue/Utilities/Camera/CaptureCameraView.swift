//
//  CameraTestView.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/3/25.
//

import Foundation
import SwiftUI
import AVFoundation
import SwiftfulRouting

struct CaptureCameraView: View {
    
    private let router: AnyRouter
    
    let feed: CaptureCameraFeed = CaptureCameraFeed()
    private let onCapture: (UIImage) -> Void
    private let onVideoCapture: (URL) -> Void
    
    @State var isconnectionEnabled: Bool = false
    @State var isCameraVisible: Bool = true
    
    @State var cameraPosition: AVCaptureDevice.Position = .back
    @State var isFlashlight: Bool = false
    
    @State var previewImage: UIImage? = nil
    @State var originalImage: UIImage? = nil
    
    init(
        router: AnyRouter,
        onCapture: @escaping (UIImage) -> Void,
        onVideoCapture: @escaping (URL) -> Void
    ) {
        self.router = router
        self.onCapture = onCapture
        self.onVideoCapture = onVideoCapture
    }
    
    var body: some View{
        ZStack{
            LinearGradient(colors: [.gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack{
                GeometryReader{ proxy in
                    
                    ZStack{
                        CameraPreviewView(session: feed.session, isConnectionEnabled: $isconnectionEnabled )
                            .onAppear{
                                startFeed()
                            }
                            .onDisappear{
                                stopFeed()
                            }
                        HStack{
                            ZStack{
                                if cameraPosition == .back {
                                    Button(
                                        action: {
                                            feed.setFlashLightEnabled(enabled: isFlashlight ? true : false)
                                            isFlashlight.toggle()
                                        },
                                        label: {
                                            ZStack{
                                                Circle()
                                                    .fill(.black.opacity(0.001))
                                                    .frame(width: 70)
                                                Image(systemName: isFlashlight ? "bolt.fill" : "bolt.slash.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: isFlashlight ? 18 : 24)
                                                    .foregroundStyle(Color.white)
                                                    .animation(.none, value: isFlashlight)
                                            }
                                        }
                                    )
                                    .buttonStyle(.plain)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                CameraCaptureButton(
                                    onPhotoCapture: {
                                        feed.capturePhoto(
                                            completion: { preview, original in
                                                previewImage = preview
                                                originalImage = original
                                            }
                                        )
                                    },
                                    onVideoCaptureStart: {feed.startRecording{ videoURL in
                                        onVideoCapture(videoURL)
                                    }},
                                    onVideoCaptureStop: {feed.stopRecording()}
                                )
                                    .frame(width: 70, height: 70)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Button(
                                    action: {
                                        feed.onCameraSelect(position: cameraPosition == .back ? .front : .back)
                                        if cameraPosition == .back{
                                            cameraPosition = .front
                                        }else{
                                            cameraPosition = .back
                                        }
                                    },
                                    label: {
                                        ZStack{
                                            Circle()
                                                .fill(.black.opacity(0.001))
                                                .frame(width: 70)
                                            Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.camera.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 24)
                                                .foregroundStyle(Color.white)
                                                .font(Typography.medium(size: 16))
                                        }
                                    }
                                )
                                .buttonStyle(.plain)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            .padding(20)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(height: proxy.size.height)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(.all, edges: [.top])
                    
                    HStack{
                        ZStack{
                            Button(
                                action: {router.dismissScreen()},
                                label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 16)
                                        .foregroundStyle(Color.white)
                                        .font(Typography.medium(size: 16))
                                        .padding()
                                })
                            
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Capture Vue Camera")
                                .foregroundStyle(Color.white)
                                .font(Typography.medium(size: 16))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding()
                    
                }
            }
            .overlay {
                ZStack{
                    if let image = previewImage{
                        Color.black.ignoresSafeArea()
                        Image(uiImage: image)
                            .resizable() // Make the image resizable
                            .scaledToFit() // Scale the image to fit the view proportionally
                        
                        ZStack{
                            Button(
                                action: {
                                    previewImage = nil
                                },
                                label: {Text("Retake")}
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(
                                action: {
                                    if let image = originalImage{
                                        onCapture(image)
                                    }
                                    router.dismissScreen()
                                },
                                label: {Text("Done")}
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding()
                    }
                }
            }
            .onChange(of: previewImage) { oldValue, newValue in
                if newValue == nil {
                    startFeed()
                }else{
                    stopFeed()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func startFeed(){
        feed.start()
        isconnectionEnabled = true
        feed.onCameraSelect(position: .back)
    }
    
    private func stopFeed(){
        feed.stop()
        isconnectionEnabled = false
    }
}


#Preview{
    RouterView{ router in
        CaptureCameraView(router: router, onCapture: {image in }, onVideoCapture: {_ in})
    }
}
