//
//  StoryThumbnailView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//
import SwiftUI
import SwiftfulRouting

struct StoryThumbnailView: View {
    
    @EnvironmentObject var vm: EventHomeViewModel
    
    @Binding var showStory: Bool
    @Binding var selectedStory: String
    
    @State private var frameImages: [String: UIImage] = [:]
    
    var storyNamespace: Namespace.ID
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.event.storiesList) { story in
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.001))
                                .frame(width: 76, height: 76)
                                .padding(2)
                                .background(
                                    Circle()
                                        .stroke(LinearGradient(colors: [.pink, .red, .orange], startPoint: .topTrailing, endPoint: .bottomLeading), lineWidth: 2)
                                )
                                .padding(4)
                            if !showStory || selectedStory != story.id{
                                if story.url.hasSuffix("mp4"){
                                    if let frameImage =  frameImages[story.id]{
                                        Image(uiImage: frameImage)
                                            .resizable()
                                            .matchedGeometryEffect(id: story.id, in: storyNamespace)
                                            .frame(width: 76, height: 76)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                selectedStory = story.id
                                                withAnimation(.easeInOut(duration: 0.05)) {
                                                    showStory.toggle()
                                                }
                                            }
                                    }
                                    }else{
                                        ImageLoader(url: story.url)
                                            .matchedGeometryEffect(id: story.id, in: storyNamespace)
                                            .frame(width: 76, height: 76)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                selectedStory = story.id
                                                withAnimation(.easeInOut(duration: 0.1)) {
                                                    showStory.toggle()
                                                }
                                                
                                            }
                                    }
                                }
                            }
                        .id(story.id)
                        .onAppear{
                            vm.imageFromVideo(url: URL(string: story.url)!, at: 5) { image in
                                if let image = image {
                                    self.frameImages[story.id] = image
                                }
                            }
                        }
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: selectedStory){ _, storyId in
                    withAnimation(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                            scrollView.scrollTo(storyId, anchor: .leading)
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
        StoryThumbnailView(showStory: .constant(false), selectedStory: .constant(""), storyNamespace: Namespace().wrappedValue)
            .environmentObject(vm)
    }
    
}
