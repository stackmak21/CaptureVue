//
//  EventHomeScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import SwiftUI
import SwiftfulRouting
import Kingfisher
import AVKit

struct EventHomeScreen: View {
    
    @StateObject var vm: EventHomeViewModel
    @StateObject var videoPlayer: VideoPlayerManager = VideoPlayerManager()
    
    @State var showStory: Bool = false
    @State var showGallery: Bool = false
    @State var selectedStory: String = ""
    @State var selectedGalleryItem: String = ""
    @State var allow3dRotation: Bool = false
    
    @Namespace var storyNamespace
    @Namespace var galleryNamespace
    
    init(router: AnyRouter, dataService: DataService, event: EventDto ) {
        let interactor = EventHomeInteractor(dataService: dataService)
        _vm = StateObject(wrappedValue: EventHomeViewModel(router: router, interactor: interactor, event: event))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                Rectangle()
                    .fill(Color.black.opacity(0.001))
                    .frame(height: 260)
                    .overlay {
                        ZStack{
                            ImageLoader(url: vm.event.mainImage)
                        }
                    }
                ScrollViewReader{ mainScrollReader in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0){
                            HStack{
                                Text(vm.event.eventName)
                                    .font(Typography.medium(size: 16))
                                Spacer()
                                Text(vm.event.eventName)
                                    .font(Typography.medium(size: 16))
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            
                            
                            StoryThumbnailView(
                                showStory: $showStory,
                                selectedStory: $selectedStory,
                                storyNamespace: storyNamespace
                            )
                            .padding(.vertical)
                            .environmentObject(vm)
                            
                            GalleryListView(
                                selectedGalleryItem: $selectedGalleryItem,
                                showGallery: $showGallery,
                                galleryNamespace: galleryNamespace
                            )
                            .environmentObject(vm)
                            .padding(.horizontal)
                            
                            
                        }
                    }
                    .onChange(of: selectedGalleryItem){ galleryItem in
                        withAnimation(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                                mainScrollReader.scrollTo(galleryItem, anchor: .bottom)
                            }
                        }
                    }
                    
                }
            }
            .ignoresSafeArea()

            if showGallery{
                GalleryView(
                    showGallery: $showGallery,
                    selectedGalleryItem: $selectedGalleryItem,
                    galleryNamespace: galleryNamespace
                )
                .zIndex(1)
                .environmentObject(vm)
            }
            
            if showStory{
                StoryView(
                    showStory: $showStory,
                    allow3dRotation: $allow3dRotation,
                    selectedStory: $selectedStory,
                    storyNamespace: storyNamespace
                )
                .environmentObject(vm)
                .zIndex(1)
            }
        }
    }
}


#Preview {
    let dev = DeveloperPreview.instance
    let dataService = DataServiceImpl()
    RouterView{ router in
        EventHomeScreen(router: router, dataService: dataService, event: dev.event)
    }
}











