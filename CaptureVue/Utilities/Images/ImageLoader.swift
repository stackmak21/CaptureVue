//
//  ImageLoader.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/11/24.
//

import SwiftUI
import Kingfisher


struct ImageLoader: View {
    let url: String
    
    let capturedImage: ((UIImage) -> Void)?
    
    init(
        url: String,
        capturedImage: ((UIImage) -> Void)? = nil
    ) {
        self.url = url
        self.capturedImage = capturedImage
    }
    
    var body: some View {
            if let urlValue = URL(string: url) {
                GeometryReader { proxy in
                    KFImage(urlValue)
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .frame(width: proxy.size.width, height: proxy.size.height)
                        }
                        .loadDiskFileSynchronously()
                        .fade(duration: 0)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                }
            }
        
    }
}

#Preview {
    ImageLoader(
        url: "https://picsum.photos/800/1007"
    )
    .frame(width: 300, height: 300)
}
