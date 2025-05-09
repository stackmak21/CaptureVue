//
//  StoryItemBundle.swift
//  SwiftStoriesKit
//
//  Created by Paris Makris on 16/3/25.
//

import Foundation

 struct StoryBundle: Identifiable{
    
     let id: String
     var stories: [Story]
     let previewUrl: String
     let type: MediaType
     let creator: Customer
     var currentStoryIndex: Int
     var storyTimer: CGFloat
     var isStoryBundleSeen: Bool {
        var isSeen: Bool = true
        stories.forEach { story in
            if !story.isSeen {
                isSeen = false
            }
        }
        return isSeen
    }
    
     init(
        id: String = "",
        stories: [Story] = [],
        previewUrl: String = "",
        type: MediaType = .photo,
        creator: Customer = Customer(),
        currentStoryIndex: Int = 0,
        storyTimer: CGFloat = 0
    ) {
        self.id = id
        self.stories = stories
        self.previewUrl = previewUrl
        self.type = type
        self.creator = creator
        self.currentStoryIndex = currentStoryIndex
        self.storyTimer = storyTimer
    }
    
     mutating func goToNextStory() {
        if currentStoryIndex < stories.count - 1 {
            currentStoryIndex += 1
            stories[currentStoryIndex].isSeen = true
        }
    }
    
     mutating func goToPreviousStory() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        }
    }
    
     mutating func goToNextStory(with index: Int) {
        if currentStoryIndex < stories.count - 1 {
            currentStoryIndex = index
        }
    }
    
     mutating func updateTimer(){
        
        storyTimer += getStep(duration: 3)
    }
    
    private func getStep(duration: CGFloat) -> CGFloat{
        return 0.03 / duration
    }
    
     mutating func resetTimeToCurrentIndex(){
        if currentStoryIndex < stories.count - 1 {
            currentStoryIndex += 1
        }
        storyTimer = CGFloat(currentStoryIndex)
    }
}


 struct Story: Identifiable, Hashable {
     var id: String = UUID().uuidString
     let imageURL: String
     var isSeen: Bool
    
     init(imageURL: String, isSeen: Bool = false) {
        self.imageURL = imageURL
        self.isSeen = isSeen
    }
    
     mutating func storyShowed(){
        isSeen = true
    }
}

