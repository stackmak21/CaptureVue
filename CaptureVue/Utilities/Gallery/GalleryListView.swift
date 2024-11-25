//
//  GalleryListView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//

import SwiftUI
import SwiftfulRouting

struct GalleryListView: View {
    
    @EnvironmentObject var vm: EventHomeViewModel
    
    @Binding var selectedGalleryItem: String
    @Binding var showGallery: Bool
    
    var galleryNamespace: Namespace.ID
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
            ForEach(Array(vm.event.galleryList.enumerated()), id: \.offset) { index, galleryItem in
                ZStack{
                    Rectangle()
                        .fill(Color.black.opacity(0.001))
                        .frame(height: 160)
                    if !showGallery || selectedGalleryItem != galleryItem.id{
                        ImageLoader(url: galleryItem.publicUrl)
                            .matchedGeometryEffect(id: galleryItem.id, in: galleryNamespace)
                            .frame(height: 160)
                            .onTapGesture {
                                selectedGalleryItem = galleryItem.id
                                withAnimation {
                                    showGallery.toggle()
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
    let dev = DeveloperPreview.instance
    let dataService = DataServiceImpl()
    RouterView{ router in
        let vm = EventHomeViewModel(router: router, interactor: EventHomeInteractor(dataService: dataService), event: dev.event)
        GalleryListView(selectedGalleryItem: .constant(""), showGallery: .constant(true), galleryNamespace: Namespace().wrappedValue)
            .environmentObject(vm)
    }
}
