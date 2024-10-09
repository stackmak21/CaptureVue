//
//  ContentView.swift
//  CaptureVue
//
//  Created by Paris Makris on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(uiImage: Asset.Illustrations.image1.image)
                .padding()
                .background(.black)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(Typography.bold(size: 30))
            Text("Hello, world!")
                .font(Typography.medium(size: 30))
            Text("Hello, world!")
                .font(Typography.regular(size: 30))
            Text("Hello, world!")
                .font(Typography.light(size: 30))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

