//
//  StoryView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//
import SwiftUI
import SwiftfulRouting


struct StoryView: View {
    
    @EnvironmentObject var vm: EventHomeViewModel
    @EnvironmentObject var videoManager: VideoPlayerManager
    
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    
    @Binding var showStory: Bool
    @Binding var allow3dRotation: Bool
    @Binding var selectedStory: String
    
    var storyNamespace: Namespace.ID
    
    private let deviceHeight: Double = UIScreen.self.main.bounds.height
    
    var body: some View {
        ZStack{
            Color.black.opacity(opacity).ignoresSafeArea()
            TabView(selection: $selectedStory){
                ForEach(vm.event.storiesList){ story in
                    GeometryReader{ proxy in
                        Group{
                            if story.url.hasSuffix(".mp4"){
                                VideoPlayerView(player: videoManager.player)
                                    .onAppear{
                                        videoManager.setVideoToPlayer(videoUrl: story.url)
                                        videoManager.playVideo()
                                    }
                                    .onDisappear{
                                        videoManager.pauseVideo()
                                    }
                            }else{
                                ImageLoader(url: story.url)
                            }
                        }
                        .tag(story.id)
                        .rotation3DEffect(allow3dRotation ? getAngle(proxy: proxy) : .zero , axis: (x:0, y:1, z:0), anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing, perspective: 0.5)
                    }
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            allow3dRotation = true
                        }
                    }
                }
                
            }
            .matchedGeometryEffect(id: selectedStory, in: storyNamespace)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .offset(y: offsetY)
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
        if dy >= 0.0 {
            offsetY = dy/2
            scale = 1 - ((dy/deviceHeight)/10)
            opacity = 1 - (dy/deviceHeight)
        }
    }
    
    private func onDragEnded(_ value: DragGesture.Value){
        let dy = value.translation.height
        
        if dy >= 0.0 {
            if dy <= deviceHeight / 2 {
                withAnimation {
                    offsetY = 0.0
                    scale = 1.0
                    opacity = 1.0
                }
            }else{
                allow3dRotation = false
                if !allow3dRotation{
                    withAnimation(.easeInOut(duration: 0.1)){
                        showStory.toggle()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                    offsetY = 0.0
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
    
    private func getAngle(proxy: GeometryProxy) -> Angle {
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let rotationAngle: CGFloat = 75
        let degrees = rotationAngle * progress
        return Angle(degrees: Double(degrees))
    }
}


#Preview {
    let dev = DeveloperPreview.instance
    let dataService = DataServiceImpl()
    RouterView{ router in
        let vm = EventHomeViewModel(router: router, interactor: EventHomeInteractor(dataService: dataService), event: dev.event)
        StoryView(showStory: .constant(true), allow3dRotation: .constant(true), selectedStory: .constant(""), storyNamespace: Namespace().wrappedValue)
            .environmentObject(vm)
    }
}






