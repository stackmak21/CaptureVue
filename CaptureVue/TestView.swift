//
//  TestView.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/11/24.
//

import SwiftUI
import AVKit

struct TestView: View {
    @State var isPlaying: Bool = false
    @State var player: AVPlayer? = {
        return .init(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!)
    }()
    
    var body: some View {
        VStack{
            if let player{
                VideoPlayerView(player: player)
                    
                    .overlay {
                        Button("Play") {
                            player.play()
                        }
                    }
            }
        }
    }
}

#Preview {
    TestView()
}
