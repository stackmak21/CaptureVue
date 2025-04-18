//
//  ContentView.swift
//  CaptureVueAppClip
//
//  Created by Paris Makris on 13/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Fatal Error", action: {
                fatalError("Fatal error Paris")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
