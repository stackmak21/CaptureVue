//
//  ImagePrefetcher.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/11/24.
//

import Foundation
import Kingfisher
import SwiftUI

final class ImagePrefetcher {
    
    static let instance = ImagePrefetcher()
    
    var prefetchers: [String: Kingfisher.ImagePrefetcher] = [:]
    
    private init() {}
    
    func startPrefetching(eventID: String, urls: [String]){
        let imageUrls = urls.compactMap({ URL(string: $0) })
        prefetchers[eventID] = Kingfisher.ImagePrefetcher(urls: imageUrls)
        prefetchers[eventID]?.start()
    }
    
    func stopPrefetching(eventID: String, urls: [URL]){
        prefetchers[eventID]?.stop()
    }
}


final class ImageDownloader{
    
    static let instance = ImageDownloader()
    
    private init(){}
    
    func downloadImage(with url: String, completion: @escaping (UIImage?) -> Void){
        guard let imageURL = URL(string: url) else { return }
        let downloader = Kingfisher.ImageDownloader.default
        downloader.downloadImage(with: imageURL) { result in
            switch result{
            case .success(let value):
                let uiImage = UIImage(data: value.originalData)
                completion(uiImage)
            case .failure(let error):
                print("Failed to download image with KingFisher and error: \(error.localizedDescription)")
            }
        }
    }
}


