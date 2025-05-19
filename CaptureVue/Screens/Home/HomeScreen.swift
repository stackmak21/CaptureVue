//
//  HomeScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import SwiftUI
import SwiftfulRouting

struct HomeScreen: View {
    
    @StateObject var vm: HomeViewModel
    
    @State var isPresented: Bool = false

    init(router: AnyRouter, client: NetworkClient, customerRepositoryMock: CustomerRepositoryContract? = nil) {
        _vm = StateObject(wrappedValue:HomeViewModel(router: router, client: client, customerRepositoryMock: customerRepositoryMock))
    }
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            ScrollView{
                VStack{
                    HStack{
                        Text("Events")
                            .font(Typography.regular(size: 16))
                        Spacer()
                        Button {
                            isPresented = true
                        } label: {
                            HStack(spacing: 4){
                                
                                Image(systemName: "camera")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(Color.white)
                                Text("Join")
                                    .foregroundStyle(Color.white)
                                    .font(Typography.medium(size: 12))
                            }
                            .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .buttonStyle(PlainButtonStyle())
                        Button(
                            action: {
                                vm.goToSettings()
                            },
                            label: {
                                Image(systemName: "gear")
                            }
                        )
                    }
                    HStack{
                        titleWithCounter(title: "Hosting Events", counter: vm.hostEvents.count)
                        Spacer()
                        Button {
                            vm.goToCreateEvent()
                        } label: {
                            HStack(spacing: 4){
                                Text("Create Event")
                                    .foregroundStyle(Color.white)
                                    .font(Typography.medium(size: 16))
                            }
                            .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    EventListings(
                        events: vm.hostEvents,
                        onEventClick: {
                            vm.goToEvent(eventId: $0.id)
                        }
                    )
                    Divider()
                        .padding(.vertical)
                    titleWithCounter(title: "Participating Events", counter: vm.participatingEvents.count)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    EventListings(
                        events: vm.participatingEvents,
                        onEventClick: {
                            vm.goToEvent(eventId: $0.id)
                        }
                    )
                    Spacer()
                }
                .padding()
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Logout")
                        .onTapGesture {
                            vm.logoutUser()
                        }
                }
                ToolbarItem(placement: .principal) {
                    Text("My title")
                }
            }
            .sheet(isPresented: $isPresented) {
                QRCodeScannerScreen(onQrString: { qrCode in
                    vm.analyzeQrCode(qrCodeString: qrCode)
                    isPresented = false
                })
                .presentationDetents([.medium])
                .onDisappear() {
                    
                }
            }
            .onAppear {
//                vm.dismissScreenStack()
                vm.fetchEvents()
//                NotificationManager.scheduleNotification(title: "New Notificaton", subtitle: "Paris notification Sceduled")
            }
        }
        
    }
    
    @ViewBuilder func titleWithCounter(title: String, counter: Int) -> some View {
        let color: Color = .black
        HStack(spacing: 4){
            Text(title)
                .foregroundStyle(color)
                .font(Typography.regular(size: 14))
            Text("(\(counter))")
                .foregroundStyle(color)
                .font(Typography.regular(size: 14))
        }
    }
}

#Preview {
    RouterView{ router in
        HomeScreen(router: router, client: NetworkClient(), customerRepositoryMock: CustomerRepositoryMock())
    }
}


struct EventListings: View {
    
    let events: [Event]
    let onEventClick: (Event) -> Void
    
    var body: some View {
        ForEach(events, id: \.id){ event in
            Button(
                action: {
                    onEventClick(event)
                },
                label: {
                    VStack{
                        HStack{
                            
                            if !event.mainImage.isEmpty {
                                    ImageLoader(
                                        url: event.mainImage
                                    )
                                    .frame(width: 40, height: 40)
                                        
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
//                                            ImageLoader(url: event.mainImage)
//                                                .frame(width: 40, height: 40)
//                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                            else{
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 40, height: 40)
                            }
                            Text(event.eventName)
                                .font(Typography.medium(size: 16))
                        }
                        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                        .background(.gray.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            )
            .buttonStyle(PlainButtonStyle())
            
        }
    }
}
