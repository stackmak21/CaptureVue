//
//  QRCodeIcon.swift
//  CaptureVue
//
//  Created by Paris Makris on 2/11/24.
//

import SwiftUI

struct QRCodeIcon: View {
    
    @State var isAnimating: Bool = false
    
    var foreveranimation: Animation {
        Animation.easeInOut(duration: 2).repeatForever()
    }
    
    var body: some View {
        VStack{
            GeometryReader{
                let size = $0.size
                ZStack{
                    ForEach(0...4, id: \.self){ index in
                        let rotation = Double(index) * 90
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .miter))
                            .rotationEffect(.init(degrees: rotation))
                            .scaleEffect(1.04)
                            .foregroundStyle(Color.red)
                        
                        
                        
                    }
                    
                }
                .frame(width: size.width, height: size.height)
                
//                .overlay(alignment: .top){
//                    Rectangle()
//                        .stroke(lineWidth: 2)
//                        .frame(height: 1)
//                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isAnimating ? -15 : 15)
//                        .animation(foreveranimation, value: isAnimating)
//                        .offset(y: isAnimating ? size.width : 0)
//                        
//                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .onAppear(){
            withAnimation {
                isAnimating  = true
            }
        }
    }
}

#Preview {
    QRCodeIcon()
        .padding()
}
