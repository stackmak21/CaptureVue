//
//  SwiftStoriesKitTest.swift
//  CaptureVue
//
//  Created by Paris Makris on 24/3/25.
//

import SwiftUI



struct SwiftStoriesKitTest: View {
    
    @State var selectedStory: Int = 1
    
    var body: some View {
//        VStack{
//            TabView(selection: $selectedStory) {
//                ForEach(1...6) { recId in
//                    GeometryReader{ geo in
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 8)
//                                .frame(width: geo.size.width, height: geo.size.height)
//                                .padding(40)
//                            Text("\(recId)")
//                                .foregroundStyle(Color.white)
//                        }
//                        .tag(recId)
//                    }
//                }
//                
//            }
//            .animation(.easeInOut(duration: 2), value: selectedStory)
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            
//            
//            
//            Button(
//                action: {
//                    selectedStory += 1
//                },
//                label: {
//                    Text("Move to ")
//                })
//        }
        SwiftStories()
    }
}

#Preview {
    SwiftStoriesKitTest()
}
