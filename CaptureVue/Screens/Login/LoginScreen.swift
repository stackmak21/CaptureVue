//
//  LoginScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import SwiftUI
import SwiftfulRouting

struct LoginScreen: View {
    
    
    @StateObject var vm: LoginViewModel
    
    @FocusState private var focusedField: FocusedField?
    @FocusState var isUsernameFocused: Bool
    
    init(router: AnyRouter, client: NetworkClient, authRepositoryMock: AuthRepositoryContract? = nil) {
        _vm = StateObject(wrappedValue: LoginViewModel(router: router, client: client, authRepositoryMock: authRepositoryMock))
    }
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack{
                ImageLoader(
                    url: "https://picsum.photos/802/1017"
                )
                .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
                
                TextField(text: $vm.email) {
                    Text("Enter your username")
                        .font(Typography.medium(size: 12))
                }
                .onSubmit {
                    focusedField = .password
                }
                .focused($focusedField, equals: .username)
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
                    Text("Login")
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
                    action: { vm.goToRegisterScreen() },
                    label: {
                        Text("Don't have an account? Register")
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
                focusedField = .username
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

extension LoginScreen {
    enum FocusedField{
        case username
        case password
    }
}




#Preview {
    RouterView{ router in
        LoginScreen(router: router, client: NetworkClient(), authRepositoryMock: AuthRepositoryMock())
    }
}
