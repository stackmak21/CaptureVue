//
//  StoryThumbnailView.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/11/24.
//
import SwiftUI
import PhotosUI

struct StoryThumbnailView: View {
    
    let storiesList: [StoryItem]
    let storyNamespace: Namespace.ID
    
    @Binding var showStory: Bool
    @Binding var selectedStory: String
    
    let onAddstoryClick: () -> Void
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    AddStoryButton(onClick: onAddstoryClick)
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
        onAddstoryClick: {}
    )
}


struct AddStoryButton: View {
    
    let onClick: () -> Void
    
    var body: some View {
        ZStack{
            ImageLoader(url: "https://picsum.photos/800/1003")
                .frame(width: 78, height: 78)
                .clipShape(Circle())
                
        }
        .onTapGesture {
            onClick()
        }
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "plus")
                .renderingMode(.template)
                .padding(4)
                .background(.red)
                .clipShape(Circle())
        }
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
