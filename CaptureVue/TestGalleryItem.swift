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
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack{
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(galleryList) { item in
                        ZStack{
                            Rectangle()
                                .frame(height: 200)
                            ImageLoader(url: item.publicUrl)
                                .matchedGeometryEffect(id: item.id, in: galleryNamespace)
                                .frame(height: 200)
                        }
                        .transition(.scale(scale: 0.99))
                        .onTapGesture {
                            selectedImage = item
                            showGallery = true
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
                .onTapGesture {
                    showGallery = false
                }
            }
        }
        .animation(.spring(duration: 1), value: showGallery)
    }
}

#Preview {
    TestGalleryItem(galleryList: DeveloperPreview.instance.galleryList)
        .padding()
}
