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
                .scale(0.90)
                .scaleEffect(isTapped ? 0.94 : 1, anchor: .center)
                .foregroundStyle(Color.white)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.white)
                }
        }
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: 20,
            perform: {
                withAnimation {
                    impactHeavy.impactOccurred()
                    isTapped = true
                    onClick()
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
        Color.blue.ignoresSafeArea()
        CameraCaptureButton(onClick: {})
            .frame(width: 60)
    }
}
