//
//  QRCodeIcon.swift
//  CaptureVue
//
//  Created by Paris Makris on 2/11/24.
//

import SwiftUI

struct QRCodeIcon: View {
    
    let color: Color
    
    @State var isAnimating: Bool = false
    
    var foreveranimation: Animation {
        Animation.easeInOut(duration: 1).repeatForever()
    }
    
    var body: some View {
        VStack{
            GeometryReader{
                let size = $0.size
                ZStack{
                    ForEach(0...4, id: \.self){ index in
                        let rotation = Double(index) * 90
                        
                        RoundedRectangle(cornerRadius: 14, style: .circular)
                            .trim(from: 0.6, to: 0.65)
                            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .miter))
                            .rotationEffect(.init(degrees: rotation))
                            .scaleEffect(isAnimating ? 1.04 : 1.08)
                            .foregroundStyle(color)
                            .animation(foreveranimation, value: isAnimating)
                        
                        
                        
                    }
                    
                }
                .frame(width: size.width, height: size.width)
                
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
    QRCodeIcon(color: Color.red)
        .frame(width: 200)
        .padding()
}
