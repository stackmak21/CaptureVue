//
//  EventHomeViewModel.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import Foundation
import AVKit
import SwiftfulRouting
import SwiftUI


@MainActor
class EventHomeViewModel: ObservableObject {
    
    private let router: AnyRouter
    private let interactor: EventHomeInteractor
    private var tasks: [Task<Void, Error>] = []
    
    
    @KeychainStorage("server_token") var token = ""
    
    @Published var event: EventDto
    
    init(
        router: AnyRouter,
        interactor: EventHomeInteractor,
        event: EventDto
    ) {
        self.router = router
        self.interactor = interactor
        self.event = event
    }
    
    deinit {
        tasks.forEach{$0.cancel()}
    }

    
    func imageFromVideo(url: URL, at time: TimeInterval, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVURLAsset(url: url)

            let assetIG = AVAssetImageGenerator(asset: asset)
            assetIG.appliesPreferredTrackTransform = true
            assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

            let cmTime = CMTime(seconds: time, preferredTimescale: 60)
            let thumbnailImageRef: CGImage
            do {
                thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
            } catch let error {
                print("Error: \(error)")
                return completion(nil)
            }

            DispatchQueue.main.async {
                completion(UIImage(cgImage: thumbnailImageRef))
            }
        }
    }
    
}





