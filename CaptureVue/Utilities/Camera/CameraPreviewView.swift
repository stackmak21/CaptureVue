//
//  CameraPreviewView.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/3/25.
//

import SwiftUI
import AVKit

struct CameraPreviewView: UIViewRepresentable {
    
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    @Binding var isConnectionEnabled: Bool
    
    init(session: AVCaptureSession, isConnectionEnabled: Binding<Bool>) {
        self.session = session
        _isConnectionEnabled = isConnectionEnabled
    }
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 30
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        uiView.videoPreviewLayer.connection?.isEnabled = isConnectionEnabled
    }
}
