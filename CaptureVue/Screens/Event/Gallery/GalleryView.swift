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
        
        ZStack{
//            Color.black.opacity(opacity).ignoresSafeArea()
            ZStack{
                TabView(selection: $selectedGalleryItem){
                    ForEach(galleryList){ galleryItem in
                        GeometryReader{ geo in
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
//                                        Rectangle()
//                                            .frame(width: geo.size.width)
//                                            .foregroundStyle(Color.yellow)
//                                            .clipped()
//                                            .tag(galleryItem.id)
//                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
//                                Button(
//                                    action: {
//                                        //
//                                        //                                        ImageDownloader.instance.downloadImage(with: galleryItem.publicUrl) { fetchedImage in
//                                        //                                            if let image = fetchedImage{
//                                        //                                                let imageSaver = ImageSaver()
//                                        //                                                imageSaver.writeToPhotoAlbum(image: image)
//                                        //                                            }
//                                        //                                        }
//                                        print("ASSET URL: \(galleryItem.publicUrl)")
//                                        onDownloadClick(galleryItem.publicUrl, galleryItem.dataType)
//                                        
//                                    },
//                                    label: {
//                                        Image(systemName: "square.and.arrow.down.on.square.fill")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 32)
//                                            .foregroundStyle(Color.red)
//                                    }
//                                )
//                                .buttonStyle(.plain)
//                                .padding()
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            }
                            .tag(galleryItem.id)
                        }
                    }
                }
                .matchedGeometryEffect(id: selectedGalleryItem, in: galleryNamespace)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle())
                .offset(y: offsetY)
                .scaleEffect(scale)
            }
            
            
        }
        .transition(.scale(scale: 0.99))
        
        .gesture(
            DragGesture()
                .onChanged(onDrag)
                .onEnded(onDragEnded)
        )
        
    }
    
    private func onDrag(_ value: DragGesture.Value) {
        let dy = value.translation.height
        if dy >= 0.0 {
            offsetY = dy/2
            scale = 1 - ((dy/deviceHeight)/10)
            opacity = 1 - (dy/deviceHeight)
        }
    }
    
    private func onDragEnded(_ value: DragGesture.Value){
        
        let dy = value.translation.height
        
        if dy >= 0.0 {
            if dy <= deviceHeight / 10 {
                withAnimation {
                    offsetY = 0.0
                    scale = 1.0
                    opacity = 1.0
                }
            }else{
                DispatchQueue.main.async{
                    withAnimation(.spring(duration: 0.16)){
                        showGallery = false
                    }
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


//ZStack {
//    ZStack{
//        TabView(selection: $selectedStory) {
//            ForEach(storiesBundle) { story in
//                GeometryReader { geo in
//                    StoryContentView(
//                        story: story,
//                        geo: geo,
//                        isInternalThumbnailShown: $isInternalThumbnailShown,
//                        timerProgress: $timerProgress
//                    )
//                    .onAppear{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//                            if let bundleIndex = storiesBundle.firstIndex(where: {$0.id == selectedStory}){
//                                if selectedStory == story.id{
//                                    storiesBundle[bundleIndex].stories[story.currentStoryIndex].storyShowed()
//                                }
//                            }
//                            
//                        }
//                    }
//                    .tag(story.id)
//                    .onTapGesture(coordinateSpace: .global){ actionBasedOnTapLocation($0, geo, story)}
//                    .onChange(of: geo.frame(in: .global).minX){ minX in
//                        if minX != 0{
//                            isTimerPaused = true
//                        }else{
//                            isTimerPaused = false
//                            
//                            if let bundleIndex = storiesBundle.firstIndex(where: {$0.id == selectedStory}){
//                                if bundleIndex < storiesBundle.count - 1 {
//                                    storiesBundle[bundleIndex + 1].storyTimer = CGFloat(storiesBundle[bundleIndex + 1].currentStoryIndex)
//                                }
//                                if bundleIndex > 0 {
//                                    storiesBundle[bundleIndex - 1].storyTimer = CGFloat(storiesBundle[bundleIndex - 1].currentStoryIndex)
//                                }
//                            }
//                            
//                        }
//                    }
//                    .rotation3DEffect(isInternalThumbnailShown ? getAngle(proxy: geo) : .zero , axis: (x:0, y:1, z:0), anchor: geo.frame(in: .global).minX > 0 ? .leading : .trailing, perspective: 0.5)
//                }
//            }
//        }
//        .disabled(animationDebounce)
//        .matchedGeometryEffect(id: isInternalThumbnailShown ? "" : selectedStory , in: storyNamespace)
//        .tabViewStyle(.page(indexDisplayMode: .never))
//        .indexViewStyle(PageIndexViewStyle())
//        .animation(.spring(duration: 0.1), value: selectedStory)
//        //        .onChange(of: selectedStory) { storyID in
//        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
//        //                animationDebounce = false
//        //            }
//        //        }
//        
//    }
//    //    if showStory && !isInternalThumbnailShown{
//    //        if let story = storiesBundle.first(where: { $0.id == selectedStory}){
//    //            ImageLoaderCircle(url: story.previewUrl)
//    //                .matchedGeometryEffect(id: story.id, in: thumbnailNamespace)
//    //                .frame(width: 30, height: 30)
//    //                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//    //                .padding()
//    //                .padding(.top, 6)
//    //        }
//    //    }
//}
//.transition(.scale(scale: 0.99))
//.offset(y: offsetY)
//.scaleEffect(scale)
//.gesture(
//    DragGesture()
//        .onChanged(onDrag)
//        .onEnded(onDragEnded)
//)
//
