//
//  GalleryItem.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/11/24.
//

import SwiftUI

struct GalleryItemView: View {
    let galleryItem: GalleryItem
    let onClick: () -> Void
    
    var body: some View {
        GeometryReader{ proxy in
            VStack(spacing: 0){
                
                ImageLoader(
                    url: galleryItem.publicUrl
                )
                .frame(height: proxy.size.height * 5/6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(height: proxy.size.height / 6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    HStack(spacing: 4){
                        
                        Text(galleryItem.customer.firstName)
                                .font(Typography.medium(size: 8))
                        Text(galleryItem.customer.lastName)
                                .font(Typography.medium(size: 8))

                    }
                }
            }
            .onTapGesture {
                onClick()
            }
            
        }
        .clipShape( RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 4)
    }
}

#Preview {
    let dev = DeveloperPreview.instance
    ZStack{
        Color.green
        GalleryItemView(galleryItem: dev.galleryItem, onClick: {})
            .frame(width: 80, height: 100)
    }
        
}
