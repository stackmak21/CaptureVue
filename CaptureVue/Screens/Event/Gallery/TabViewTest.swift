//
//  TabViewTest.swift
//  CaptureVue
//
//  Created by Paris Makris on 13/4/25.
//

import SwiftUI

struct TabViewTest: View {
    
    @Namespace private var tabNamespace
    
    @State var tabID: Int = 1
    
    var body: some View {
        VStack{
            Spacer()
            TabView(selection: $tabID){
                HStack{
                ForEach(1...3) { tabid in
                    if tabid > 1{
                        Spacer()
                    }
                    ZStack{
                        Button(
                            action: {
                                tabID = tabid
                            },
                            label: {
                                Image(systemName: "iphone.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.red)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50)
                            }
                        )
                        if tabid == tabID{
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 70, height: 70)
                                .opacity(0.4)
                                .matchedGeometryEffect(id: "identifier", in: tabNamespace)
                        }
                    }
                        .id(tabid)
                    }
                }
            }
            .animation(.easeInOut, value: tabID)
        }
        .padding()
    }
}

#Preview {
    TabViewTest()
}
