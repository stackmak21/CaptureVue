//
//  AuthRepository.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

//MARK: - Repository

class AuthRepository: AuthRepositoryContract {
    
    
    private let authApi: AuthApi
    private let keychain: KeychainManager = KeychainManager()
    
    init(client: NetworkClient) {
        self.authApi = AuthApi(client: client)
    }
    

    
    func login(_ credentials: Credentials) async -> Result<LoginResponse, CaptureVueResponseRaw> {
        return await authApi.login(
            LoginRequestBody(
                email: credentials.email,
                password: credentials.password,
                deviceId: keychain.get(key: .deviceId) ?? ""
            )
        )
        .map({ $0.toLoginResponse() })
        .mapError({ $0 })
    }
    
    func guestLogin() async -> Result<LoginResponse, CaptureVueResponseRaw> {
        
        return await authApi.guestLogin(
            GuestLoginRequestBody(
                deviceId: keychain.get(key: .deviceId) ?? ""
            )
        )
        .map({ $0.toLoginResponse() })
    }
    
}
