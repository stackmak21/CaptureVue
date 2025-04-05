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

import SwiftStoriesKit


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

    
    
    @State var myDate: Date = Date.now
    
    @State var selectedVideo: PhotosPickerItem?
    @State var selectedFiles: [PhotosPickerItem] = []
    
    
    @Namespace var storyNamespace
    @Namespace var galleryNamespace
    
    
    init(router: AnyRouter, client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil, galleryRepositoryMock: GalleryRepositoryContract? = nil, eventId: String ) {
        _vm = StateObject(wrappedValue: EventViewModel(router: router, client: client, eventRepositoryMock: eventRepositoryMock , galleryRepositoryMock: galleryRepositoryMock ,eventId: eventId ))
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
                                    onAddstoryClick: { vm.isMediaPickerPresented.toggle() }
                                )
                                .padding(.vertical)
                                
                                HStack{
                                    PhotosPicker(selection: $vm.selectedFiles)
                                    {
                                        HStack{
                                            Image(systemName: "camera")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundStyle(Color.black)
                                                .frame(width: 20, height: 20)
                                            Text("Add Photo To Gallery")
                                                .font(Typography.medium(size: 20))
                                                .foregroundStyle(Color.black)
                                        }
                                    }
                                }
                                .padding(.bottom)
                                
                                
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
        
        
        .overlay(alignment: .top, content: {
            if vm.filesToUpload != 0 {
                UploadprogressBanner(progress: $vm.uploadProgress, filesToUpload: vm.filesToUpload)
            }
        })
        .sheet(isPresented: $vm.isMediaPickerPresented, content: {
            HStack{
                Button(
                    action: {
                        vm.isPhotoPickerPresented.toggle()
                    },
                    label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                            Image(systemName: "photo.on.rectangle.angled.fill")
                                .resizable()
                                .foregroundStyle(Color.black)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                        }
                })
                Button(
                    action: {vm.openCamera()},
                    label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                            Image(systemName: "camera.fill")
                                .resizable()
                                .foregroundStyle(Color.black)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                        }
                })
            }
            .padding(.horizontal)
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
                .photosPicker(
                    isPresented: $vm.isPhotoPickerPresented,
                    selection: $vm.selectedStoryItem,
                    maxSelectionCount: 1,
                    matching: .any(of: [.images, .videos])
                )
        })
        .onChange(of: vm.selectedStoryItem, { oldValue, newValue in
            if oldValue != newValue {
                vm.isMediaPickerPresented.toggle()
            }
        })
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Event")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        vm.goBack()
                    }
            }
            
        }
        .onAppear( perform: vm.fetchCustomerEvent)
        .onAppear {
            if let url = vm.event.galleryList.first?.publicUrl{
                print("Photo URL 🔥🔥🔥🔥🔥" + url)
            }
        }
//        .onChange(of: vm.selectedFiles, convertToFileUrlPath)
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
        EventScreen(router: router, client: NetworkClient(), eventRepositoryMock: EventRepositoryMock(), galleryRepositoryMock: GalleryRepositoryMock(), eventId: "cp-12345")
    }
//    UploadprogressBanner(progress: 70, filesUploaded: 1, filesToUpload: 5)
}


struct UploadprogressBanner: View {
    @Binding var progress: Double
    let filesToUpload: Int
    
    @State private var filesUploaded: Int = 0
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundStyle(.thinMaterial)
                VStack{
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(.linear)
                    HStack{
                        Text("\(filesUploaded)/\(filesToUpload)")
                            .font(Typography.medium(size: 12))
                        Text("\(Int(progress))/100")
                            .font(Typography.medium(size: 12))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.top, 2)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onChange(of: progress) { oldValue, newValue in
            if newValue >= 100 {
                filesUploaded += 1
                progress = 0
            }
        }
    }

}











