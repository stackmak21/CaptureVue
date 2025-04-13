//
//  VideoPlayerView.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/11/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        return controller
    }
    
    func updateUIViewController(_ uiView: AVPlayerViewController, context: Context) {
      
    }
    
}


