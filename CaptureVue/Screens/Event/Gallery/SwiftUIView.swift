//
//  SwiftUIView.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import SwiftUI

class networker{
    
    
    func completionFunc(completion: @escaping () -> Void){
        
        log.warning("Before Completion", showCurrentThread: true)
        DispatchQueue.global().asyncAfter(deadline: .now() +  3){
            completion()
        }
        log.warning("After Completion", showCurrentThread: true)
        
    }
    
    func completionFuncCaller() async {
        await withCheckedContinuation { continuation in
            completionFunc {
                log.warning("completion Executed", showCurrentThread: true)
                continuation.resume()
            }
        }
    }
    
    func asyncTask1() async {
        log.error("AsyncTask", showCurrentThread: true)
        print("asyncTask 1 first")
        try? await Task.sleep(nanoseconds: 4_000_000_000)
        await completionFuncCaller()
        print("asyncTask 1 second")
    }
    
    
}

struct SwiftUIView: View {
    
    let nw = networker()
    
    @State var isBig: Bool = false
    @State var myText: String = ""
    
    @Namespace var namespace
    var body: some View {
        VStack{
            Text("Device Identifier: \(UIDevice.current.identifierForVendor?.uuidString ?? "N/A")")
            Text(myText)
            Text("isBig = \(isBig)")
            RoundedRectangle(cornerRadius: 8)
                .matchedGeometryEffect(id: isBig ? "" : "rect", in: namespace, properties: .size, anchor: .center, isSource: false)
                .foregroundStyle(Color.red)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    syncFunc()
                }
            
            RoundedRectangle(cornerRadius: 8)
                .matchedGeometryEffect(id: "rect", in: namespace, isSource: true)
                .frame(width: 30, height: 30)
                .opacity(isBig ? 0.0001 : 0.001)
                .onTapGesture {
                    isBig.toggle()
                    Task{
                        
                        log.info("Before AWait", showCurrentThread: true)
                        await nw.asyncTask1()
                        log.info("After Await", showCurrentThread: true)
                        
                    }
                }
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
                .onAppear{
//                    DispatchQueue.global(qos: .default).async {
//                        print("Dispatch first 1")
//                        DispatchQueue.main.async {
//                            print("Dispatch Started")
//                        }
//                        Thread.sleep(forTimeInterval: 2)
//                        DispatchQueue.main.async {
//                            print("Dispatch Finished")
//                        }
//                        print("Dispatch second 2")
//                    }
                    
                }
        }
        .animation(.easeInOut, value: isBig)
    }
    
    
    func syncFunc(){
        print("SyncFunc First")
        let startTime = CFAbsoluteTimeGetCurrent() // Start time
        log.success("sync func started ")
        for i in 1...9000000{
            if i % 1000000 == 0{
                print("Sync task \(i)")
            }
        }
        print("sync func ended")
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        log.success("sync func ended with time")
        
    }
    

}

#Preview {
    SwiftUIView()
}
