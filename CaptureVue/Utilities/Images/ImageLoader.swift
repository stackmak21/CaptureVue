//
//  ImageLoader.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/11/24.
//

import SwiftUI
import Kingfisher

struct ImageLoader: View {
    let url: URL
    
    var body: some View {
        Rectangle()
            .opacity(0)
            .overlay {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .clipped()
        
    }
}

#Preview {
    ImageLoader(url: URL(string: "https://picsum.photos/800/1001")!)
}
