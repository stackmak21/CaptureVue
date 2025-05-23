//
//  CameraView.swift
//  CaptureVue
//
//  Created by Paris Makris on 30/10/24.
//

import SwiftUI
import AVKit

struct QRCameraView: UIViewRepresentable {
    
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
    @Binding var qrRect: CGRect
    let rectBounds: ((CGRect) -> Void)?
    
    init(session: AVCaptureSession, isConnectionEnabled: Binding<Bool>, qrRect: Binding<CGRect>, completion: ((CGRect) -> Void)?) {
        self.session = session
        _isConnectionEnabled = isConnectionEnabled
        rectBounds = completion
        _qrRect = qrRect
        
    }
    
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
        rectBounds?(uiView.videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: qrRect))
    }
}


