//
//  StoryThumbnailView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//
import SwiftUI
import SwiftfulRouting
import PhotosUI

struct StoryThumbnailView: View {
    
    let storiesList: [StoryItem]
    let storyNamespace: Namespace.ID
    
    @Binding var showStory: Bool
    @Binding var selectedStory: String
    @Binding var selectedStoryItem: [PhotosPickerItem]
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    AddStoryButton(selectedStoryItem: $selectedStoryItem)
                    ForEach(storiesList) { story in
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
                        .id(story.id)
                    }
                }
                .padding(.horizontal)
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
}

#Preview {
    let dev = DeveloperPreview.instance
    StoryThumbnailView(
        storiesList: dev.event.storiesList,
        storyNamespace: Namespace().wrappedValue,
        showStory: .constant(false),
        selectedStory: .constant(""),
        selectedStoryItem: .constant([])
    )
}


struct AddStoryButton: View {
    
    @Binding var selectedStoryItem: [PhotosPickerItem]
    
    var body: some View {
        PhotosPicker(
            selection: $selectedStoryItem,
            maxSelectionCount: 1,
            matching: .any(of: [.images, .videos]),
            label: {
                ZStack{
                    ImageLoader(url: "https://picsum.photos/800/1003")
                        .frame(width: 78, height: 78)
                        .clipShape(Circle())
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "plus")
                        .renderingMode(.template)
                        .padding(4)
                        .background(.red)
                        .clipShape(Circle())
                }
            }
        )
    }
}

//        PhotosPicker("Select a Photo", selection: $selectedItem, matching: .images)
//            .onChange(of: selectedItem) { oldImage, newImage in
//                Task {
//                    if let data = try? await newImage?.loadTransferable(type: Data.self) {
//                        if let selectedImage = UIImage(data: data) {
//                            vm.eventImage = selectedImage
//                        }
//                    }
//                }
//            }
