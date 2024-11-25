//
//  VideoPlayerManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/11/24.
//

import Foundation
import AVKit

class VideoPlayerManager: ObservableObject {
    @Published var player: AVPlayer = AVPlayer()
    
    init() { }
    
    func setVideoToPlayer(videoUrl: String) {
        player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: videoUrl)!))
    }
    
    func playVideo() {
        player.play()
    }
    
    func pauseVideo() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
    
    func stopVideo() {
        player.seek(to: CMTime.zero)
        player.pause()
    }
}
