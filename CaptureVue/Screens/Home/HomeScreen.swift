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

    init(router: AnyRouter, dataService: DataService) {
        _vm = StateObject(wrappedValue:HomeViewModel(router: router, interactor: HomeInteractor(dataService: dataService)))
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
                            vm.goToHome()
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
                    }
                    HStack{
                        titleWithCounter(title: "Hosting Events", counter: vm.events.count)
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
                    ForEach(vm.events, id: \.id){ event in
                        Button(
                            action: {
                                vm.goToEvent(event: event)
                            },
                            label: {
                                VStack{
                                    HStack{
                                        if !event.mainImage.isEmpty{
                                            ImageLoader(url: event.mainImage)
                                                .frame(width: 40, height: 40)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                        }else{
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
                    Divider()
                        .padding(.vertical)
                    titleWithCounter(title: "Participating Events", counter: vm.events.count)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding()
                
            }
            
            .navigationBarItems(trailing: Text("Trailing"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My title")
                        
                }
            }
//            .toolbarBackground(.red, for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                vm.fetchEvents()
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
    let dataService = DataServiceImpl()
    RouterView{ router in
        HomeScreen(router: router, dataService: dataService)
    }
}
