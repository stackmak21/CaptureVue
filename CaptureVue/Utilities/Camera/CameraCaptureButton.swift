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
    
    let onClick: () -> Void
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundStyle(Color.white)
            Circle()
                .scale(0.94)
                .foregroundStyle(Color.black)
            Circle()
                .scale(0.88)
                .scaleEffect(isTapped ? 0.86 : 1, anchor: .center)
                .foregroundStyle(Color.white)
        }
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: 20,
            perform: {
                withAnimation {
                    impactHeavy.impactOccurred()
                    isTapped = true
                }
            },
            onPressingChanged: { press in
                withAnimation {
                    isTapped = press
                }
            }
        )
        
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        CameraCaptureButton(onClick: {})
            .frame(width: 60)
    }
}
