//
//  GalleryVideoPlayer.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/4/25.
//

import SwiftUI
import AVKit

struct GalleryVideoPlayer: View {
    // video url: http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
    
    @State var player = AVPlayer()
    @State var videoImage: UIImage?
    
    var body: some View {
        GeometryReader{ proxy in
            VStack{
                ZStack{
                    VideoPlayerView(player: player)
                        .frame(width: proxy.size.width, height: proxy.size.height)
//                        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    
//                    if let image = videoImage{
//                        
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                    }
                }

            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            if let videoUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"){
                player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
                videoImage = videoSnapshot(videoURL: videoUrl)
                player.play()
            }
            
        }
    }
    
    func videoSnapshot(videoURL: URL) -> UIImage? {

//        let vidURL = URL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: 4, preferredTimescale: 60)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
}

#Preview {
    GalleryVideoPlayer()
}
