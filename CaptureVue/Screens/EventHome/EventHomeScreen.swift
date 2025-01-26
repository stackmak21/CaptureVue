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
    @State var offsetY: CGRect = .zero
    @State var position: CGRect = .zero
    @State var opacity: CGFloat = 1
    @State var opacity1: CGFloat = 0
    
    @State var myDate: Date = Date.now
    
    
    @Namespace var storyNamespace
    @Namespace var galleryNamespace
    
    
    init(router: AnyRouter, dataService: DataService, event: EventDto ) {
        let interactor = EventHomeInteractor(dataService: dataService)
        _vm = StateObject(wrappedValue: EventHomeViewModel(router: router, interactor: interactor, event: event))
    }
    
    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: 0){
                    Rectangle()
                        .fill(Color.black.opacity(0.001))
                        .frame(height: 260)
                        .overlay {
                            ZStack{
                                ImageLoader(url: vm.event.mainImage)
                                HStack{
                                    Text(vm.event.eventName)
                                        .font(Typography.medium(size: 16))
                                    Spacer()
                                    Text(vm.event.eventName)
                                        .font(Typography.medium(size: 16))
                                }
                                .opacity(calculateOpacity())
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            }
                        }
                    
                    ScrollViewReader{ mainScrollReader in
                        ScrollView(showsIndicators: false) {
                            GeometryReader{ geo in
                                VStack(spacing: 0){
                                    HStack{
                                        Text(vm.event.eventName)
                                            .font(Typography.medium(size: 16))
                                            .frameReader{ rect in
                                                position = rect
                                            }
                                        Spacer()
//                                        Text(vm.event.expires.asDateString())
//                                            .font(Typography.medium(size: 16))
//                                            .onTapGesture {
//                                                triggerDatePickerPopover(pickerId: "datePicker")
//                                                print("Clicked 🔥🔥🔥🔥🔥")
//                                            }
                                            
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    storyThumbnailView()
                                    galleryListView()
                                }
                                .frameReader{ rect in
                                    offsetY = rect
                                }
                            }
                        }
                        .onChange(of: selectedGalleryItem){ galleryItem in
                            withAnimation(){
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                                    mainScrollReader.scrollTo(galleryItem, anchor: .bottom)
                                }
                            }
                        }
                        .refreshable {
                            
                        }
                    }
                }
                .ignoresSafeArea()
                galleryCarousel()
                storyCarousel()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func calculateOpacity() -> CGFloat{
        if offsetY.minY < 240{
            let a = 1/20 * ((offsetY.minY - 210) - 5)
            return 1 - a
        }
        return 0
    }

    @ViewBuilder func storyCarousel() -> some View{
        if showStory{
            StoryView(
                showStory: $showStory,
                allow3dRotation: $allow3dRotation,
                selectedStory: $selectedStory,
                storyNamespace: storyNamespace
            )
            .environmentObject(vm)
            .environmentObject(videoPlayer)
            .zIndex(1)
        }
    }
    
    @ViewBuilder func galleryCarousel() -> some View{
        if showGallery{
            
            GalleryView(
                showGallery: $showGallery,
                selectedGalleryItem: $selectedGalleryItem,
                galleryNamespace: galleryNamespace
            )
            .environmentObject(vm)
            .environmentObject(videoPlayer)
            .zIndex(1)
            
        }
    }
    
    @ViewBuilder func storyThumbnailView() -> some View{
        StoryThumbnailView(
            showStory: $showStory,
            selectedStory: $selectedStory,
            storyNamespace: storyNamespace
        )
        .padding(.vertical)
        .environmentObject(vm)
    }
    
    @ViewBuilder func galleryListView() -> some View{
        GalleryListView(
            selectedGalleryItem: $selectedGalleryItem,
            showGallery: $showGallery,
            galleryNamespace: galleryNamespace
        )
        .environmentObject(vm)
        .padding(.horizontal)
    }
}


#Preview {
    let dev = DeveloperPreview.instance
    let dataService = DataServiceImpl()
    RouterView{ router in
        EventHomeScreen(router: router, dataService: dataService, event: dev.event)
    }
}

struct GeometryGetter: View {
    let coordinateSpace: CoordinateSpace
    let action: (CGRect) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Text("")
                .onChange(of: geometry.frame(in: coordinateSpace)) { rect in
                    action(rect)
                }
        }
    }
}


extension View {
    func frameReader(coordinateSpace: CoordinateSpace = .global, perform action: @escaping (CGRect) -> Void) -> some View {
        self.background(GeometryGetter(coordinateSpace: coordinateSpace, action: action))
    }
}


extension NSObject {
  func accessibilityDescendant(passing test: (Any) -> Bool) -> Any? {

    if test(self) { return self }

    for child in accessibilityElements ?? [] {
      if test(child) { return child }
      if let child = child as? NSObject, let answer = child.accessibilityDescendant(passing: test) {
        return answer
      }
    }

    for subview in (self as? UIView)?.subviews ?? [] {
      if test(subview) { return subview }
      if let answer = subview.accessibilityDescendant(passing: test) {
        return answer
      }
    }

    return nil
  }
}

extension NSObject {
  func accessibilityDescendant(identifiedAs id: String) -> Any? {
    return accessibilityDescendant {
      // For reasons unknown, I cannot cast a UIView to a UIAccessibilityIdentification at runtime.
      return ($0 as? UIView)?.accessibilityIdentifier == id
      || ($0 as? UIAccessibilityIdentification)?.accessibilityIdentifier == id
    }
  }
    
    func buttonAccessibilityDescendant() -> Any? {
        return accessibilityDescendant { ($0 as? NSObject)?.accessibilityTraits == .button }
      }
}


extension View{
  func triggerDatePickerPopover(pickerId: String) {
    if
      let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let window = scene.windows.first,
      let picker = window.accessibilityDescendant(identifiedAs: pickerId) as? NSObject,
      let button = picker.buttonAccessibilityDescendant() as? NSObject
    {
      button.accessibilityActivate()
    }
  }
}









