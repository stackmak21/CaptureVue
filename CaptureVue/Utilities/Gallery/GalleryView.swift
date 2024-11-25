//
//  GalleryView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//

import SwiftUI
import SwiftfulRouting


struct GalleryView: View {
    
    @EnvironmentObject var vm: EventHomeViewModel
    
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    
    @Binding var showGallery: Bool
    @Binding var selectedGalleryItem: String
    
    var galleryNamespace: Namespace.ID
    
    private let deviceHeight: Double = UIScreen.self.main.bounds.height
    
    var body: some View {
        ZStack{
            Color.black.opacity(opacity).ignoresSafeArea()
            TabView(selection: $selectedGalleryItem){
                ForEach(vm.event.galleryList){ galleryItem in
                    GeometryReader{ proxy in
                        ImageLoader(url: galleryItem.publicUrl)
                            .tag(galleryItem.id)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .matchedGeometryEffect(id: selectedGalleryItem, in: galleryNamespace)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .offset(x: offsetX, y: offsetY)
            .scaleEffect(scale)
            .gesture(
                DragGesture()
                    .onChanged(onDrag)
                    .onEnded(onDragEnded)
            )
        }
    }
    
    private func onDrag(_ value: DragGesture.Value) {
        let dy = value.translation.height
        let dx = value.translation.width
        if dy >= 0.0 {
            offsetY = dy/2
            offsetX = dx/2
            scale = 1 - ((dy/deviceHeight)/4)
            opacity = 1 - (dy/deviceHeight)
        }
    }
    
    private func onDragEnded(_ value: DragGesture.Value){
        let dy = value.translation.height
        
        
        if dy >= 0.0 {
            if dy <= deviceHeight / 2 {
                withAnimation {
                    offsetX = 0.0
                    offsetY = 0.0
                    scale = 1.0
                    opacity = 1.0
                }
            }else{
                withAnimation(.easeOut(duration: 0.2)){
                    showGallery.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                    offsetX = 0.0
                    offsetY = 0.0
                    scale = 1.0
                    opacity = 1.0
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
        GalleryView(showGallery: .constant(true), selectedGalleryItem: .constant(""), galleryNamespace: Namespace().wrappedValue)
            .environmentObject(vm)
    }
}

