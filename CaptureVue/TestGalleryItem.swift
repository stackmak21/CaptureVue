//
//  TestGalleryItem.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/5/25.
//

import SwiftUI

struct TestGalleryItem: View {
    
    let galleryList: [GalleryItem]
    
    @State var selectedImage: GalleryItem? = nil
    
    @Namespace var galleryNamespace
    
    @State var showGallery: Bool = false
    
    @State var offsetY: CGFloat = 0
    @State var scale: CGFloat = 0
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack{
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(galleryList) { item in
                        ZStack{
                            Rectangle()
                                .frame(height: 200)
                            if !showGallery && item.id != selectedImage?.id ?? "" {
                                ImageLoader(url: item.publicUrl)
                                    .matchedGeometryEffect(id: item.id, in: galleryNamespace)
                                    .frame(height: 200)
                            }
                                
                        }
                        .transition(.scale(scale: 0.99))
                        .onTapGesture {
                            selectedImage = item
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8), {
                                showGallery = true
                                offsetY = 300
                                scale = 0.4
                            }, completion: {
                                withAnimation(.spring(response: 0.2, dampingFraction: 2)) {
                                    offsetY = 0
                                    scale = 1
                                }
                            })
//                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
//                                offsetY = 300 // push down
//                                scale = 0.95
//                                showGallery = true
//                            }
                            
                        }
                    }
                }
            }
            if let image  = selectedImage, showGallery{
                ZStack{
                    ImageLoader(url: image.publicUrl)
                        .matchedGeometryEffect(id: image.id, in: galleryNamespace)
                }
                .transition(.scale(scale: 0.99))
                .offset(y: offsetY)
                .scaleEffect(scale)
                .onTapGesture {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        offsetY = 0 // push down
                        scale = 1
                        showGallery = false
                        selectedImage = nil
                    }
                }
            }
        }
//        .animation(.spring(duration: 1), value: showGallery)
    }
}

#Preview {
    TestGalleryItem(galleryList: DeveloperPreview.instance.galleryList)
        .padding()
}
