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
    
    var body: some View {
        ZStack{
            if let urlValue = URL(string: url) {
                KFImage(urlValue)
                    .resizable(resizingMode: .stretch)
                }
        }
    }
}

#Preview {
    ImageLoader(url: "https://picsum.photos/800/1001")
}
