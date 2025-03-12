//
//  testtest.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/3/25.
//

import SwiftUI

struct testtest: View {
    @State var textHeight: CGFloat = 0
    @State var isVisible: Bool = false
    
    var body: some View {
        ZStack{
            
            CameraTestView()
                .padding(.top, !isVisible ? 0 : textHeight)
            
            if isVisible{
                ZStack{
                    Rectangle()
                        .frame(height: textHeight)
                        .frame(maxWidth: .infinity)
                    
                    HStack{
                        Spacer()
                        Text("jfdsjfsdj fjdsgdfhj jfsdhfkjsd fjhskdfjhds fjhsdkfjsd  gd gdf gdf g fdg df gdf g dfg fd gdf g fd gdf")
                            .foregroundColor(Color.white)
                            .font(Typography.regular(size: 12))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 8)
                        Spacer()
                    }
                    .background(Color.yellow.ignoresSafeArea(edges: []))
                    .frameReader(perform: {rect in
                        textHeight = rect.height
                    })
                }
                .frame(height: textHeight)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            Button(action: {isVisible.toggle()}, label: {Text("ffjhdjd")})
        }
    }
}

#Preview {
    ZStack{
        Color.red.ignoresSafeArea()
        testtest()
    }
}
