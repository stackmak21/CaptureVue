//
//  CameraCaptureButton.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/3/25.
//

import SwiftUI


struct CameraCaptureButton: View {
    
    @State var isTapped: Bool = false
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    @State var isVideo: Bool = false
    
    @State private var currentPhase: Phase = .initial
    
    let onPhotoCapture: () -> Void
    let onVideoCaptureStart: () -> Void
    let onVideoCaptureStop: () -> Void
    
    var body: some View {
        ZStack{
            Group{
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(Color.white)
                Circle()
                    .scale(0.90)
                    .scaleEffect(currentPhase.scale)
                    .foregroundStyle(currentPhase.foregroundStyle)
            }
                .onLongPressGesture(
                    minimumDuration: 0.4,
                    maximumDistance: 20,
                    perform: {
                        withAnimation(completionCriteria: .logicallyComplete) {
                            currentPhase = .videoStarted
                        } completion: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                                currentPhase = .videoRecording
                            }
                        }
                        isVideo = true
                        onVideoCaptureStart()
                    },
                    onPressingChanged: {
                        if !isVideo{
                            isTapped = $0
                            currentPhase = .onLongTap
                            if !$0 {
                                onPhotoCapture()
                            }
                        }
                        if !$0{
                            isTapped = false
                            isVideo = false
                            currentPhase = .initial
                        }
                    }
                )
                .onChange(of: isVideo) {
                    if !isVideo{
                        onVideoCaptureStop()
                    }
                }
            
        }
        .animation(.bouncy, value: isTapped)
        .animation(.interactiveSpring(duration: 0.2), value: currentPhase)
    }
    
    enum Phase: CaseIterable{
        case initial, onLongTap, videoStarted, videoRecording
        
        var foregroundStyle: Color {
            switch self {
            case .initial: .white
            case .videoStarted: .red
            case .videoRecording: .red
            case .onLongTap: .white
            }
        }
        
        var scale: Double{
            switch self {
            case .initial: 1
            case .onLongTap: 0.9
            case .videoStarted: 1.15
            case .videoRecording: 0.88
            }
        }
    }
}

#Preview {
    ZStack{
        Color.blue.ignoresSafeArea()
        CameraCaptureButton(onPhotoCapture: {print("on Photo Capture")}, onVideoCaptureStart: {print("on Video Start")}, onVideoCaptureStop: {print("on Video Stop")})
            .frame(width: 60)
    }
}
