//
//  GalleryListView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//

import SwiftUI
import SwiftfulRouting
import AVKit

struct GalleryListView: View {
    
    @EnvironmentObject var vm: EventHomeViewModel
    
    @Binding var selectedGalleryItem: String
    @Binding var showGallery: Bool
    
    
    @State private var frameImages: [String: UIImage] = [:]
    
    var galleryNamespace: Namespace.ID
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
            ForEach(Array(vm.event.galleryList.enumerated()), id: \.offset) { index, galleryItem in
                ZStack{
                    Rectangle()
                        .fill(Color.black.opacity(0.001))
                        .frame(height: 120)
                    if !showGallery || selectedGalleryItem != galleryItem.id{
                        if galleryItem.publicUrl.hasSuffix("mp4"){
                            if let frameImage =  frameImages[galleryItem.id]{
                                Image(uiImage: frameImage)
                                    .resizable()
                                    .matchedGeometryEffect(id: galleryItem.id, in: galleryNamespace)
                                    .frame(height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                .onTapGesture {
                                    selectedGalleryItem = galleryItem.id
                                    withAnimation(.easeInOut(duration: 0.1)){
                                        showGallery.toggle()
                                    }
                                }
                            }
                        }else{
                            ImageLoader(url: galleryItem.publicUrl)
                                .matchedGeometryEffect(id: galleryItem.id, in: galleryNamespace)
                                .frame(height: 120)
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
                .onAppear{
                    vm.imageFromVideo(url: URL(string: galleryItem.publicUrl)!, at: 5) { image in
                        if let image = image {
                                    self.frameImages[galleryItem.id] = image
                                }
                    }
                }
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
