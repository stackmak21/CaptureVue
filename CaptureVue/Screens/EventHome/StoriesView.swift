//
//  StoriesView.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/11/24.
//

import SwiftUI

struct StoriesView: View {
    let stories: [StoryDataDto]
    
    @State var isStoriesOpen: Bool = false
    @State var selectedStory: StoryDataDto?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(stories) { story in
                    Button {
                        selectedStory = story
                    } label: {
                        StoryImage(url: story.url)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .overlay{
            if let selectedStory = selectedStory {
                ImageLoader(url: URL(string: selectedStory.url)!)
                    .ignoresSafeArea()
            }
        }
        .scrollIndicators(.hidden)
            
    }
}

#Preview {
    StoriesView(stories: [
        StoryDataDto(id: "075e147b-a701-4eaa-a1a6-b5467a857516", url: "https://picsum.photos/805/1000", previewUrl: "", type: .photo),
        StoryDataDto(id: "075e147b-a701-4eaa-a1a6-b5157a857516", url: "https://picsum.photos/801/1000", previewUrl: "", type: .photo),
        StoryDataDto(id: "075e147b-a701-4eaa-a1a6-b5166a857516", url: "https://picsum.photos/802/1000", previewUrl: "", type: .photo),
        StoryDataDto(id: "075e147b-a701-4eaa-a1a6-b5167f857516", url: "https://picsum.photos/803/1000", previewUrl: "", type: .photo),
        StoryDataDto(id: "075e147b-a701-4eaa-a146-b5167a857516", url: "https://picsum.photos/804/1000", previewUrl: "", type: .photo),
        StoryDataDto(id: "075e147b-a701-4eaa-a136-b5167a857516", url: "https://picsum.photos/805/1000", previewUrl: "", type: .photo),
        StoryDataDto(id: "075e147b-a701-4eaa-a176-b5167a857516", url: "https://picsum.photos/806/1000", previewUrl: "", type: .photo),
        StoryDataDto(id: "075e147b-a701-4eaa-a196-b5167a857516", url: "https://picsum.photos/807/1000", previewUrl: "", type: .photo)
    ])
}

struct StoryImage: View {
    let url: String
    
    var body: some View {
        ImageLoader(url: URL(string: url)!)
            .frame(width: 80, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
    }
}
