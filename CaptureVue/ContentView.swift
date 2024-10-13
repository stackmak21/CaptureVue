//
//  ContentView.swift
//  CaptureVue
//
//  Created by Paris Makris on 8/10/24.
//

import SwiftUI
import SwiftfulRouting

struct ContentView: View {
    let router: AnyRouter
    let data: String?
    
    init(router: AnyRouter, data: String? = nil) {
        self.router = router
        self.data = data
    }
    
    var body: some View {
        VStack {
            Image(uiImage: Asset.Illustrations.image1.image)
                .padding()
                .background(.black)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(Strings.helloWorld)
                .font(Typography.bold(size: 30))
                .italic()
            Text("Hello, world!")
                .font(Typography.medium(size: 30))
                .italic()
            Text("Hello, world!")
                .font(Typography.regular(size: 30))
            Text("Hello, world!")
                .font(Typography.light(size: 30))
                .italic()
            Text("Hello, world!")
                .italic()
            if let data {
                Text(data)
                    .font(Typography.bold(size: 50))
            }
          
            
                
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}

