//
//  CoverScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 16/4/25.
//

import SwiftUI
import SwiftfulRouting

struct CoverScreen: View {
    
    @StateObject var vm: CoverViewModel
    
    
    init(router: AnyRouter, client: NetworkClient,  eventId: String, eventRepositoryMock: EventRepositoryContract? = nil) {
        self._vm = StateObject(wrappedValue: CoverViewModel(router: router, client: client, eventId: eventId, eventRepositoryMock: eventRepositoryMock))
    }
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            ImageLoader(url: vm.event.mainImage)
                .frame(width: 240, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .rotationEffect(Angle(degrees: 4), anchor: .center)
                .padding(.bottom, 20)
            Text(/*@START_MENU_TOKEN@*/"CaptureVue"/*@END_MENU_TOKEN@*/)
                .font(.custom("SnellRoundhand", size: 30))
                .padding(.bottom, 10)
            Divider()
                .background(Color.black)
                .padding(.horizontal, 100)
                .padding(.bottom)
            Text("Event Test")
                .font(Typography.regular(size: 22))
            Text("Your POV is requested")
                .font(Typography.regular(size: 12))
                .foregroundStyle(Color.gray)
                .padding(.bottom)
            Button(
                action: {
                    vm.goToEvent()
                },
                label: {
                    Text("Enter Event")
                        .frame(maxWidth: 300)
                        .foregroundStyle(Color.white)
                        .padding(.vertical)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
            )
            .buttonStyle(.plain)
            .padding(.top)
            Text("By signin in, you agree to our terms and conditions.")
                .font(Typography.light(size: 14))
                .foregroundStyle(Color.gray)
                .padding(.top, 10)
            
                
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            vm.handleUserAuthentication()
        }
    }
}

#Preview {
    RouterView{ router in
        CoverScreen(router: router, client: NetworkClient(), eventId: "cp-10001", eventRepositoryMock: EventRepositoryMock())
    }
}
