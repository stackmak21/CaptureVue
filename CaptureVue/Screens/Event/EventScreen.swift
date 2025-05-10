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
    
    @State var stories: [StoryBundle] = StoriesDeveloperPreview.stories
    
    @Namespace private var thumbnailNamespace
    @Namespace private var storyNamespace
    
    @State private var selectedStory: String = ""
    @State private var showStory: Bool = false
    
    @State private var isInternalThumbnailShown: Bool = false
    
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    @State private var showInfo: Bool = false
    
    @State var timerProgress: CGFloat = 0
    
    private let deviceHeight: Double = UIScreen.self.main.bounds.height
    
    
    @State var isQRCodeSheetPresented: Bool = false
    
    
    
    @StateObject var vm: EventViewModel
    @StateObject var videoPlayer: VideoPlayerManager = VideoPlayerManager()
    
    //    @State var showStory: Bool = false
    @State var showGallery: Bool = false
    //    @State var selectedStory: String = ""
    @State var selectedGalleryItem: String = ""
    @State var allow3dRotation: Bool = false
    //    @State var offsetY: CGRect = .zero
    @State var position: CGRect = .zero
    
    
    
    @State var myDate: Date = Date.now
    
    @State var selectedVideo: PhotosPickerItem?
    @State var selectedFiles: [PhotosPickerItem] = []
    
    @State var x: CGFloat = 0
    @State var y: CGFloat = 0
    
    @State var imageToUpload: UIImage?
    
    
    //    @Namespace var storyNamespace
    @Namespace var galleryNamespace
    
    
    init(router: AnyRouter, client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil, galleryRepositoryMock: GalleryRepositoryContract? = nil, downloadRepositoryMock: DownloadRepositoryMock? = nil, eventId: String ) {
        _vm = StateObject(wrappedValue: EventViewModel(router: router, client: client, eventRepositoryMock: eventRepositoryMock , galleryRepositoryMock: galleryRepositoryMock, downloadRepositoryMock: downloadRepositoryMock,eventId: eventId ))
    }
    
    var body: some View {
        ZStack {
            if vm.event.isValid(){
                VStack(spacing: 0){
                    ImageLoader(
                        url: vm.event.mainImage,
                        capturedImage: { imageToUpload = $0 }
                    )
                    .frame(height: 260)
                    .onAppear{
                        ImagePrefetcher.instance.startPrefetching(eventID: vm.eventId, urls: [vm.event.qrCodeImage])
                    }
                    .overlay {
                        HStack{
                            Text(vm.event.eventName)
                                .foregroundStyle(.white)
                                .font(Typography.medium(size: 16))
                            
                            Spacer()
                            Button(
                                action: {
                                    vm.showAlert()
//                                    vm.uploadBanner()
//                                    let imageSaver = ImageSaver()
//                                    if let imagetoUpload = imageToUpload{
//                                        imageSaver.writeToPhotoAlbum(image: imagetoUpload)
//                                    }
                                },
                                label: {
                                    Image(systemName: "square.and.arrow.down.on.square.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20)
                                        .foregroundStyle(Color.white)
                                }
                            )
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                    
                    
                    ScrollViewReader{ mainScrollReader in
                        ScrollView(showsIndicators: true) {
                            
                            LazyVStack(spacing: 0){
                                
                                HStack{
                                    Text(vm.event.eventName)
                                        .font(Typography.medium(size: 16))
                                        .frameReader{ rect in
                                            position = rect
                                        }
                                    Spacer()
                                    
                                    Button {
                                        isQRCodeSheetPresented = true
                                    } label: {
                                        Image(systemName: "qrcode.viewfinder")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 22)
                                            .foregroundStyle(Color.black)
                                    }

                                    
                                    
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                
//                                StoryCarousel(
//                                    storyBundles: $stories,
//                                    showStory: $showStory,
//                                    isInternalThumbnailShown: $isInternalThumbnailShown,
//                                    selectedStory: $selectedStory,
//                                    thumbnailNamespace: thumbnailNamespace,
//                                    storyNamespace: storyNamespace
//                                )
//                                .zIndex(1)
                                
                                
                                StoryThumbnailView(
                                    storiesList: vm.event.storiesList,
                                    storyNamespace: storyNamespace,
                                    showStory: $showStory,
                                    selectedStory: $selectedStory,
                                    onAddstoryClick: { vm.isMediaPickerPresented.toggle() }
                                )
                                .padding(.vertical)
                                
//                                StoryCarousel(
//                                    storyBundles: $vm.stories,
//                                    showStory: $showStory,
//                                    isInternalThumbnailShown: $isInternalThumbnailShown,
//                                    selectedStory: $selectedStory,
//                                    thumbnailNamespace: thumbnailNamespace,
//                                    storyNamespace: storyNamespace
//                                )
                                
                                
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
                                .animation(nil, value: showGallery)
                                .padding(.horizontal)
                            }
//                            .frameReader{ rect in
//                                offsetY = rect
//                            }
                        }
                        
                        .onChange(of: selectedGalleryItem, {
                            scrollToCurrentGalleryItem($0, $1, mainScrollReader: mainScrollReader)
                        })
                    }
                }
                .sheet(isPresented: $isQRCodeSheetPresented, content: {
                    ZStack{
                        Color.gray.opacity(0.05).ignoresSafeArea()
                            
                            
                        VStack{
                            ImageLoader(url: vm.event.qrCodeImage)
                                .frame(width: 120, height: 120)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                            
                            ZStack{
                                
                                HStack{
                                    // https://www.capturevue.com/event/cp-10002
                                    Text(verbatim: "https://capturevue.com/event/\(vm.eventId)")
                                        .foregroundStyle(Color.black)
                                        .padding(EdgeInsets(top: 16, leading: 10, bottom: 16, trailing: 10))
                                    Spacer()
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .fill(Color.gray)
                                }
                                .overlay(content: {
                                    Button(
                                        action: {},
                                        label: {
                                            Image(systemName: "document.on.document.fill")
                                                .foregroundStyle(Color.black)
                                                .font(Typography.medium(size: 14))
                                        }
                                    )
                                    .padding(.trailing, 10)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                })
                                .padding()
                                
                            }
                            .frame(maxWidth: .infinity)
                            Button(
                                action: {},
                                label: {
                                    Text("Download")
                                        .font(Typography.medium(size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(EdgeInsets(top: 16, leading: 10, bottom: 16, trailing: 10))
                                        .background{
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(Color.black)
                                            
                                        }
                                        .padding(.horizontal, 10)
                                }
                            )
                            .buttonStyle(.plain)
                            Button(
                                action: {

                                },
                                label: {
                                    Text("Share")
                                        .font(Typography.medium(size: 14))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(EdgeInsets(top: 16, leading: 10, bottom: 16, trailing: 10))
                                        .background{
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(Color.black)
                                            
                                        }
                                        .padding(.horizontal, 10)
                                }
                            )
                            .buttonStyle(.plain)
                        }
                    }
                })
                .ignoresSafeArea()
                
                
                
                if showGallery{
                    GalleryView(
                        galleryList: vm.event.galleryList,
                        onDownloadClick: {assetURL, type in
                            vm.downloadAsset(assetURL: assetURL, assetType: type)
                        },
                        galleryNamespace: galleryNamespace,
                        showGallery: $showGallery,
                        selectedGalleryItem: $selectedGalleryItem
                    )
                    .environmentObject(videoPlayer)
                    
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
                
                Color.black.opacity(showStory ? opacity : 0).ignoresSafeArea()
                
//                if showStory{
//                    StoryFullScreenViewer(
//                        storiesBundle: $vm.stories,
//                        opacity: $opacity,
//                        showStory: $showStory,
//                        isInternalThumbnailShown: $isInternalThumbnailShown,
//                        selectedStory: $selectedStory,
//                        timerProgress: $timerProgress,
//                        thumbnailNamespace: thumbnailNamespace,
//                        storyNamespace: storyNamespace
//                    )
//                    .zIndex(10)
//                    
//                }
                
                
//                if showStory {
//                    
//                    
//                    StoryFullScreenViewer(
//                        storiesBundle: $stories,
//                        opacity: $opacity,
//                        showStory: $showStory,
//                        isInternalThumbnailShown: $isInternalThumbnailShown,
//                        selectedStory: $selectedStory,
//                        timerProgress: $timerProgress,
//                        thumbnailNamespace: thumbnailNamespace,
//                        storyNamespace: storyNamespace
//                    )
//                    
//                }
                    
                
            }
                
            
            
        }
        .animation(.spring(duration: 0.16), value: showStory)
        .animation(.spring(duration: 0.16), value: showGallery)
        
        
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
    }
    
    
    
    
    
    
    private func scrollToCurrentGalleryItem(_ oldValue: String, _ newValue: String, mainScrollReader: ScrollViewProxy) -> Void {
        withAnimation(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                mainScrollReader.scrollTo(newValue, anchor: .bottom)
            }
        }
    }
    
    private func calculateOpacity() -> CGFloat{
        //        if offsetY.minY < 240{
        //            let a = 1/20 * ((offsetY.minY - 210) - 5)
        //            return 1 - a
        //        }
        return 0
    }
}


#Preview {
    
    RouterView{ router in
        EventScreen(router: router, client: NetworkClient(), eventRepositoryMock: EventRepositoryMock(), galleryRepositoryMock: GalleryRepositoryMock(), downloadRepositoryMock: DownloadRepositoryMock(), eventId: "cp-12345")
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











