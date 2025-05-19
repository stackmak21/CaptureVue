//
//  SettingsScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/5/25.
//

import SwiftUI
import SwiftfulRouting

struct SettingsScreen: View {
    
    @StateObject var vm: SettingsViewModel
        
    init(router: AnyRouter, client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil) {
        _vm = StateObject(wrappedValue: SettingsViewModel(router: router, client: client))
    }
    
    var body: some View {
        VStack{
            Text("Settings")
                .font(Typography.medium(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Image(systemName: "person")
                Text(vm.username.isEmpty ? "Guest user" : vm.username)
                    .font(Typography.medium(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        vm.isUsernameSheetPresented = true
                    }
                    
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom)
            Text("Support")
                .font(Typography.medium(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Text Support",
                        leadingIcon: { LeadingSectionIcon("wrench.and.screwdriver.fill") }
                    )
                })
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Email Support",
                        leadingIcon: { LeadingSectionIcon("envelope.fill") }
                    )
                })
            Divider()
                .background(Color.gray)
            Text("Account")
                .font(Typography.medium(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Log Out",
                        leadingIcon: { LeadingSectionIcon("lock.fill") }
                    )
                })
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Request Account Deletion",
                        leadingIcon: { LeadingSectionIcon("envelope.fill") }
                    )
                })
            Divider()
                .background(Color.gray)
            
            Text("Follow Us")
                .font(Typography.medium(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Instagram",
                        leadingIcon: { LeadingSectionIcon("wrench.and.screwdriver.fill") }
                    )
                })
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Facebook",
                        leadingIcon: { LeadingSectionIcon("envelope.fill") }
                    )
                })
            Divider()
                .background(Color.gray)
            
            Text("Legal")
                .font(Typography.medium(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Privacy Policy",
                        leadingIcon: { LeadingSectionIcon("wrench.and.screwdriver.fill") }
                    )
                })
            Button(
                action: {},
                label: {
                    SectionItem(
                        message: "Terms of Service",
                        leadingIcon: { LeadingSectionIcon("envelope.fill") }
                    )
                })
            Divider()
                .background(Color.gray)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $vm.isUsernameSheetPresented, content: {
            VStack{
                Text("You have to provide a username to continue")
                    .font(Typography.medium(size: 14))
                    .foregroundStyle(Color.black)
                TextField("Enter your username", text: $vm.username)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action: {
                    vm.onUsernameSubmit(username: vm.username)
                },
                       label: {
                    Text("Submit")
                })
                
            }
            .padding(.horizontal)
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
        })
    }
}

#Preview {
    RouterView{ router in
        SettingsScreen(router: router, client: NetworkClient())
    }
}

//#Preview {
//    
//    RouterView{ router in
//        CreateEventScreen(router: router, client: NetworkClient(), eventRepositoryMock: EventRepositoryMock())
//    }
//}
