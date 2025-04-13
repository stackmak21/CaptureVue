//
//  SwiftUIView.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State var isBig: Bool = false
    @State var myText: String = ""
    
    @Namespace var namespace
    var body: some View {
        VStack{
            Text(myText)
            Text("isBig = \(isBig)")
            RoundedRectangle(cornerRadius: 8)
                .matchedGeometryEffect(id: isBig ? "" : "rect", in: namespace, properties: .frame, anchor: .center, isSource: false)
                .foregroundStyle(Color.red)
                .frame(width: 200, height: 200)
            
            RoundedRectangle(cornerRadius: 8)
                .matchedGeometryEffect(id: "rect", in: namespace, isSource: true)
                .frame(width: 30, height: 30)
                .onTapGesture {
                    isBig.toggle()
                }
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
                .onAppear{
                    DispatchQueue.global(qos: .default).async {
                        print("Dispatch first 1")
                        DispatchQueue.main.async {
                            myText = "Dispatc started"
                        }
                        Thread.sleep(forTimeInterval: 2)
                        DispatchQueue.main.async {
                            myText = "Dispatc finished"
                        }
                        print("Dispatch second 2")
                    }
                    Task.detached(priority: .background){
                        await asyncTask1()
                    }
                    syncFunc()
                    
                }
        }
        .animation(.easeInOut, value: isBig)
    }
    
    
    func syncFunc(){
        print("SyncFunc First")
        let startTime = CFAbsoluteTimeGetCurrent() // Start time
        
        for i in 1...5000000{
            if i % 100000 == 0{
                print("Sync task \(i)")
            }
        }
        print("sync func ended")
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("sync func ended in \(timeElapsed) seconds")
    }
    
    func asyncTask1() async {
        print("asyncTask 1 first")
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        print("asyncTask 1 second")
        await MainActor.run {
            myText = "Task Finished"
        }
    }
}

#Preview {
    SwiftUIView()
}
