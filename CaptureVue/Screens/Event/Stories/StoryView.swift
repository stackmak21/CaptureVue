//
//  StoryView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//
import SwiftUI
import SwiftfulRouting


struct StoryView: View {
    
    @EnvironmentObject var videoManager: VideoPlayerManager
    
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    @State private var showInfo: Bool = false
    
    @Binding var showStory: Bool
    @Binding var allow3dRotation: Bool
    @Binding var selectedStory: String
    
    let storiesList: [StoryItem]
    let storyNamespace: Namespace.ID
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var storyTime: Double = 0
    @State var timerIndicatorWidth: CGFloat = 0
    
    private let deviceHeight: Double = UIScreen.self.main.bounds.height
    
    var body: some View {
        ZStack{

                Color.black.opacity(opacity).ignoresSafeArea()
                TabView(selection: $selectedStory){
                    ForEach(storiesList){ story in
                        GeometryReader{ geo in
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
                                    ZStack{
                                        ImageLoader(url: story.url)
                                            .frame(width: geo.size.width)
                                            .clipped()
                                        VStack{
                                            GeometryReader{ proxy in
                                                ZStack{
                                                    Capsule()
                                                        .fill(Color.white.opacity(0.2))
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 2)
                                                    Capsule()
                                                        .fill(Color.white)
                                                        .frame(width: proxy.size.width * 0.5)
                                                        .frame(height: 2)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                            }
                                            HStack{
                                                Text("Paris Makris")
                                                Spacer()
                                                Text("Paris Makris")
                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                        .opacity(showInfo ? 0 : 1)
                                    }
                                    .onLongPressGesture(
                                        minimumDuration: 0.5,
                                        perform: {
                                            print("perform")
                                            withAnimation {
                                                showInfo.toggle()
                                            }
                                        },
                                        onPressingChanged: { pressed in
                                            withAnimation {
                                                if showInfo {
                                                    showInfo = pressed
                                                }
                                            }
                                        })
                                }
                            }
                            .tag(story.id)
                            .rotation3DEffect(allow3dRotation ? getAngle(proxy: geo) : .zero , axis: (x:0, y:1, z:0), anchor: geo.frame(in: .global).minX > 0 ? .leading : .trailing, perspective: 0.5)
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
        .onReceive(timer) { _ in
            if CGFloat(storyTime) < timerIndicatorWidth {
                storyTime += 2
            }
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
    StoryView(
        showStory: .constant(true),
        allow3dRotation: .constant(false),
        selectedStory: .constant(""),
        storiesList: DeveloperPreview.instance.event.storiesList,
        storyNamespace: Namespace().wrappedValue
    )
}








