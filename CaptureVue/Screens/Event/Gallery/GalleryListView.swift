//
//  GalleryListView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//

import SwiftUI
import SwiftfulRouting

struct GalleryListView: View {
    
    let galleryList: [GalleryItem]
    let galleryNamespace: Namespace.ID
    
    @Binding var selectedGalleryItem: String
    @Binding var showGallery: Bool
    
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10){
            ForEach(galleryList) { galleryItem in
                ZStack{
                    Rectangle()
                        .fill(Color.black.opacity(0.001))
                        .frame(height: 120)
                    if !showGallery || selectedGalleryItem != galleryItem.id{
                        GeometryReader{ geo in
                            ImageLoader(url: galleryItem.previewImage)
                                .matchedGeometryEffect(id: galleryItem.id, in: galleryNamespace)
                                .frame(width: geo.size.width, height: 120)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .padding(1)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.black.opacity(0.6))
                                )
                                .onTapGesture {
                                    selectedGalleryItem = galleryItem.id
                                    withAnimation(.easeInOut(duration: 0.1)){
                                        showGallery.toggle()
                                    }
                                }
                        }
                    }
                }
                .id(galleryItem.id)
            }
        }
    }
}

#Preview {
    GalleryListView(
        galleryList: DeveloperPreview.instance.event.galleryList,
        galleryNamespace: Namespace().wrappedValue,
        selectedGalleryItem: .constant(""),
        showGallery: .constant(false)
    )
}
