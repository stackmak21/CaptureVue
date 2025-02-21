//
//  EventScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/11/24.
//

import SwiftUI
import SwiftfulRouting
import Kingfisher
import AVKit
import PhotosUI



struct EventScreen: View {
    
    @StateObject var vm: EventViewModel
    @StateObject var videoPlayer: VideoPlayerManager = VideoPlayerManager()
    
    @State var showStory: Bool = false
    @State var showGallery: Bool = false
    @State var selectedStory: String = ""
    @State var selectedGalleryItem: String = ""
    @State var allow3dRotation: Bool = false
    @State var offsetY: CGRect = .zero
    @State var position: CGRect = .zero
    @State var opacity: CGFloat = 1
    @State var opacity1: CGFloat = 0
    
    @State var myDate: Date = Date.now
    
    @State var selectedVideo: PhotosPickerItem?
    
    
    @Namespace var storyNamespace
    @Namespace var galleryNamespace
    
    
    init(router: AnyRouter, client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil, eventId: String ) {
        _vm = StateObject(wrappedValue: EventViewModel(router: router, client: client, eventRepositoryMock: eventRepositoryMock , eventId: eventId ))
    }
    
    var body: some View {
        ZStack {
            if vm.event.isValid(){
                VStack(spacing: 0){
                    ImageLoader(
                        url: vm.event.mainImage,
                        height: 260
                    )
                        .overlay {
                            HStack{
                                Text(vm.event.eventName)
                                    .foregroundStyle(.white)
                                    .font(Typography.medium(size: 16))
                                Spacer()
                                Text(vm.event.eventName)
                                    .foregroundStyle(.white)
                                    .font(Typography.medium(size: 16))
                            }
                            .opacity(calculateOpacity())
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        }
                    
                    
                    ScrollViewReader{ mainScrollReader in
                        ScrollView(showsIndicators: true) {
                            VStack(spacing: 0){
                                
                                HStack{
                                    Text(vm.event.eventName)
                                        .font(Typography.medium(size: 16))
                                        .frameReader{ rect in
                                            position = rect
                                        }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                
                                StoryThumbnailView(
                                    storiesList: vm.event.storiesList,
                                    storyNamespace: storyNamespace,
                                    showStory: $showStory,
                                    selectedStory: $selectedStory,
                                    selectedVideo: $selectedVideo
                                )
                                .padding(.vertical)
                                
                                GalleryListView(
                                    galleryList: vm.event.galleryList,
                                    galleryNamespace: galleryNamespace,
                                    selectedGalleryItem: $selectedGalleryItem,
                                    showGallery: $showGallery
                                )
                                .padding(.horizontal)
                            }
                            .frameReader{ rect in
                                offsetY = rect
                            }
                        }
                        .onChange(of: selectedGalleryItem, {
                            scrollToCurrentGalleryItem($0, $1, mainScrollReader: mainScrollReader)
                        })
                    }
                }
                .ignoresSafeArea()
                
                
                if showGallery{
                    GalleryView(
                        galleryList: vm.event.galleryList,
                        galleryNamespace: galleryNamespace,
                        showGallery: $showGallery,
                        selectedGalleryItem: $selectedGalleryItem
                    )
                    .environmentObject(videoPlayer)
                    .zIndex(1)
                    
                }
                
                if showStory{
                    StoryView(
                        showStory: $showStory,
                        allow3dRotation: $allow3dRotation,
                        selectedStory: $selectedStory,
                        storiesList: vm.event.storiesList,
                        storyNamespace: storyNamespace
                    )
                    .environmentObject(videoPlayer)
                    .zIndex(1)
                }
            
        }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Event")
        .toolbar {
            Image(systemName: "gear")
        }
        .onAppear( perform: vm.fetchEvent)
        .onChange(of: selectedVideo, convertToFileUrlPath)
    }
    
    private func convertToFileUrlPath(_ oldValue: PhotosPickerItem?, _ newValue: PhotosPickerItem?) -> Void {
        guard let item = newValue else { return }
        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("story")
                    try data.write(to: tempURL)
                    self.vm.videoUrl = tempURL.absoluteString
                    
                }
            } catch {
                print("Error loading video: \(error)")
            }
        }
    }
    
    
    private func scrollToCurrentGalleryItem(_ oldValue: String, _ newValue: String, mainScrollReader: ScrollViewProxy) -> Void {
        withAnimation(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                mainScrollReader.scrollTo(newValue, anchor: .bottom)
            }
        }
    }
    
    private func calculateOpacity() -> CGFloat{
        if offsetY.minY < 240{
            let a = 1/20 * ((offsetY.minY - 210) - 5)
            return 1 - a
        }
        return 0
    }
}


#Preview {
    
    RouterView{ router in
        EventScreen(router: router, client: NetworkClient(), eventRepositoryMock: EventRepositoryMock(), eventId: "cp-12345")
            .environmentObject(NetworkClient())
    }
}











