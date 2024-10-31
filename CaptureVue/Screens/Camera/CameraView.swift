//
//  CameraView.swift
//  CaptureVue
//
//  Created by Paris Makris on 30/10/24.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    
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
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        uiView.videoPreviewLayer.connection?.isEnabled = isConnectionEnabled
    }
}


