//
//  RegisterScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import SwiftUI
import SwiftfulRouting

struct RegisterScreen: View {
    
    
    @StateObject var vm: RegisterViewModel
    
    @FocusState private var focusedField: FocusedField?
    @FocusState var isUsernameFocused: Bool
    
    init(router: AnyRouter, client: NetworkClient, authRepositoryMock: AuthRepositoryContract? = nil) {
        _vm = StateObject(wrappedValue: RegisterViewModel(router: router, client: client, authRepositoryMock: authRepositoryMock))
    }
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack{
                ImageLoader(
                    url: "https://picsum.photos/802/1017",
                    height: 220
                )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
                
                TextField(text: $vm.firstName) {
                    Text("First name")
                        .font(Typography.medium(size: 12))
                }
                .onSubmit {
                    focusedField = .lastName
                }
                .focused($focusedField, equals: .firstName)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 55)
                
                TextField(text: $vm.lastName) {
                    Text("Last name")
                        .font(Typography.medium(size: 12))
                }
                .onSubmit {
                    focusedField = .email
                }
                .focused($focusedField, equals: .lastName)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 55)
                
                TextField(text: $vm.email) {
                    Text("Enter your email")
                        .font(Typography.medium(size: 12))
                }
                .onSubmit {
                    focusedField = .password
                }
                .focused($focusedField, equals: .email)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 55)
                
                
                
                TextField(text: $vm.password) {
                    Text("Enter your password")
                        .font(Typography.medium(size: 12))
                }
                .focused($focusedField, equals: .password)
                .textContentType(.password)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 55)
                
                
                
                Button {
                    vm.onSubmitClicked()
                } label: {
                    Text("Register")
                        .font(Typography.medium(size: 16))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top)
                
                Button(
                    action: { vm.goToLoginScreen() },
                    label: {
                        Text("Already have acount?")
                            .foregroundStyle(Color.gray)
                    }
                )
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 10)
            }
            .padding()
            .background(RadialGradient(colors: [.white.opacity(0.5), .white], center: .center, startRadius: 0, endRadius: 400))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
            .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 4)
            .onAppear{
                focusedField = .firstName
            }
            
            if vm.isLoading {
                ProgressView()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(LinearGradient(colors: [.white.opacity(0.8), .gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 1, y: 2)
                    )
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .controlSize(.regular)
                    
            }
                
        }
    }
    
    
}

extension RegisterScreen {
    enum FocusedField{
        case firstName
        case lastName
        case email
        case password
    }
}




#Preview {
    RouterView{ router in
        RegisterScreen(router: router, client: NetworkClient(), authRepositoryMock: AuthRepositoryMock())
    }
}
