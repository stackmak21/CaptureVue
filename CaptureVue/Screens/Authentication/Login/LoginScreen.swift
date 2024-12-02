//
//  LoginScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import SwiftUI
import SwiftfulRouting

struct LoginScreen: View {
    
    enum FocusedField{
        case username
        case password
    }
    
    @StateObject var vm: LoginViewModel
    
    @FocusState private var focusedField: FocusedField?
    @FocusState var isUsernameFocused: Bool
    
    init(router: AnyRouter, dataService: DataService) {
        _vm = StateObject(wrappedValue: LoginViewModel(router: router, interactor: LoginInteractor(dataService: dataService)))
    }
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack{
                
                ImageLoader(url: "https://picsum.photos/802/1014")
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(height: 200)
                    .padding()
                
                TextField(text: $vm.username) {
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
                    vm.onLoginClicked()
                } label: {
                    Text("Login")
                        .font(Typography.medium(size: 16))
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.top)
                
                
            }
            .padding()
            .background(RadialGradient(colors: [.white.opacity(0.5), .white], center: .center, startRadius: 0, endRadius: 400))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
        }
    }
}


#Preview {
    let dataService = DataServiceImpl()
    RouterView{ router in
        LoginScreen(router: router, dataService: dataService)
    }
}
