//
//  ImagePrefetcher.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/11/24.
//

import Foundation
import Kingfisher

final class ImagePrefetcher {
    
    static let instance = ImagePrefetcher()
    
    var prefetchers: [[URL]: Kingfisher.ImagePrefetcher] = [:]
    
    private init() {}
    
    func startPrefetching(urls: [URL]){
        prefetchers[urls] = Kingfisher.ImagePrefetcher(urls: urls)
        prefetchers[urls]?.start()
    }
    
    func stopPrefetching(urls: [URL]){
        prefetchers[urls]?.stop()
    }
}
