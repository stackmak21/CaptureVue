//
//  GalleryView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//

import SwiftUI
import SwiftfulRouting
import SwiftStoriesKit


struct GalleryView: View {
    

    @EnvironmentObject var videoManager: VideoPlayerManager
    
    let galleryList: [GalleryItem]
    let onDownloadClick: (String, MediaType) -> Void
    let galleryNamespace: Namespace.ID
    
    @Binding var showGallery: Bool
    @Binding var selectedGalleryItem: String
    
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    
    private let deviceHeight: Double = UIScreen.self.main.bounds.height
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Color.black.opacity(opacity).ignoresSafeArea()
                TabView(selection: $selectedGalleryItem){
                    ForEach(galleryList){ galleryItem in
                        ZStack{
                            if galleryItem.isVideo{
                                
                                VideoPlayerView(player: videoManager.player)
                                    .onAppear{
                                        videoManager.setVideoToPlayer(videoUrl: galleryItem.publicUrl)
                                        videoManager.playVideo()
                                    }
                                    .onDisappear{
                                        videoManager.pauseVideo()
                                    }
                            }else{
                                ZStack{
                                    ImageLoader(url: galleryItem.publicUrl)
                                        .frame(width: geo.size.width)
                                        .clipped()
                                        .tag(galleryItem.id)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            Button(
                                action: {
//
//                                        ImageDownloader.instance.downloadImage(with: galleryItem.publicUrl) { fetchedImage in
//                                            if let image = fetchedImage{
//                                                let imageSaver = ImageSaver()
//                                                imageSaver.writeToPhotoAlbum(image: image)
//                                            }
//                                        }
                                    print("ASSET URL: \(galleryItem.publicUrl)")
                                    onDownloadClick(galleryItem.publicUrl, galleryItem.dataType)

                                },
                                label: {
                                    Image(systemName: "square.and.arrow.down.on.square.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 32)
                                        .foregroundStyle(Color.red)
                                }
                            )
                            .buttonStyle(.plain)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
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
                withAnimation(.easeInOut(duration: 0.1)){
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
    GalleryView(
        galleryList: dev.event.galleryList,
        onDownloadClick: {image, type in },
        galleryNamespace: Namespace().wrappedValue,
        showGallery: .constant(true),
        selectedGalleryItem: .constant("")
    )
}

