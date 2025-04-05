//
//  StoriesTest.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/3/25.
//

import SwiftUI

struct StoriesTest: View {
    
    @Namespace private var storyNamespace
    @Namespace private var thumbnailNamespace
    @State var showStory: Bool = false
    @State var selectedStory: String = "12345"
    @State var allow3dRotation: Bool = false
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack{
                        HStack {
                            ForEach(DeveloperPreview1.stories) { story in
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 80, height: 80)
                                        .opacity(0.001)
                                        RoundedRectangle(cornerRadius: 8)
                                            .matchedGeometryEffect(id: story.id, in: storyNamespace)
                                            .frame(width: 40, height: 40)
                                            .foregroundStyle(selectedStory == story.id ? .red : .black)
                                    ImageLoader(url: story.previewUrl)
                                        .matchedGeometryEffect(id: story.id, in: thumbnailNamespace)
                                        .frame(width: 80, height: 80)
                                    
                                }
                                //                            .transition(.scale(scale: 0.99))
                                .zIndex(selectedStory == story.id ? 1 : 0)
                                .onTapGesture {
                                    selectedStory = story.id
                                    showStory = true
                                }
                            }
                        }
                        Spacer()
                    }
                }
//                .scrollClipDisabled()
                Spacer()
            }
            if showStory{
                ZStack{
                    TabView(selection: $selectedStory) {
                        ForEach(DeveloperPreview1.stories){ story in
                            GeometryReader{ geo in
                                ZStack{
                                    ImageLoader(url: story.previewUrl)
                                        .frame(width: geo.size.width, height: geo.size.height)
                                        .clipped()
                                        
                                    ImageLoader(url: story.previewUrl)
                                        .matchedGeometryEffect(id: story.id, in: thumbnailNamespace)
                                        .frame(width: 40, height: 40)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        .padding()
                                }
                                .onTapGesture {
                                    showStory = false
                                }
                            }
                        }
                    }
                    .matchedGeometryEffect(id: selectedStory, in: storyNamespace)
                    .tabViewStyle(.page(indexDisplayMode: .never))
//                    .transition(.scale(scale: 0.99))
                }
                .padding(.top, 100)
                
                
            }
        }
        .animation(.spring(duration: 7), value: showStory)
    }
}

#Preview {
    StoriesTest()
}






























public struct DeveloperPreview1{
    
    public static var story: StoryItemBundle {
        let story = StoryItemBundle(
            id: "1234",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1011"
        )
        return story
    }
    
    public static var stories:  [StoryItemBundle] {
        let story1 = StoryItemBundle(
            id: "1234",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1012"
        )
        let story2 = StoryItemBundle(
            id: "12345",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1013"
        )
        let story3 = StoryItemBundle(
            id: "123456",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1014"
        )
        
        let story4 = StoryItemBundle(
            id: "1223456",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1015"
        )
        
        let story5 = StoryItemBundle(
            id: "1234565",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1017"
        )
        
        let story6 = StoryItemBundle(
            id: "1263456",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1018"
        )
        
        let story7 = StoryItemBundle(
            id: "12332456",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1024"
        )
        
        let story8 = StoryItemBundle(
            id: "123453456",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1023"
        )
        
        let story9 = StoryItemBundle(
            id: "1234422556",
            url: [
                "https://picsum.photos/800/1006",
                "https://picsum.photos/800/1007",
                "https://picsum.photos/800/1008"
            ],
            previewUrl: "https://picsum.photos/800/1029"
        )
        return [story1, story2, story3, story4, story5, story6, story7, story8, story9]
    }
}





public struct StoryItemBundle: Identifiable{
    
    public let id: String
    public let url: [String]
    public let previewUrl: String
    public let type: MediaType1
    public let creator: Creator
    
    public init(
        id: String = "",
        url: [String] = [],
        previewUrl: String = "",
        type: MediaType1 = .photo,
        creator: Creator = Creator()
    ) {
        self.id = id
        self.url = url
        self.previewUrl = previewUrl
        self.type = type
        self.creator = creator
    }
}

public struct Creator {
    
    public let id: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let createdAt: Int64
    public let isVerified: Bool
    
    public init(
        id: String = "",
        email: String = "",
        firstName: String = "",
        lastName: String = "",
        createdAt: Int64 = 0,
        isVerified: Bool = false
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.createdAt = createdAt
        self.isVerified = isVerified
    }
}


public enum MediaType1: String, Codable {
    case photo = "PHOTO"
    case video = "VIDEO"
}
