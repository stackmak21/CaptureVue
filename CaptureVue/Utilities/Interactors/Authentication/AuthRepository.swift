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
    
    func register(_ registerDetails: RegisterDetails) async -> Result<RegisterResponse, CaptureVueError> {
        return await authApi.register(
            RegistetRequestBody(
                firstName: registerDetails.firstName,
                lastName: registerDetails.lastName,
                email: registerDetails.email,
                password: registerDetails.password,
                deviceId: keychain.get(key: .deviceId) ?? ""
            )
        )
        .map({ $0.toRegisterResponse() })
        .mapError({ $0.toCaptureVueError() })
    }
    

    
    func login(_ credentials: Credentials) async -> Result<LoginResponse, CaptureVueError> {
        return await authApi.login(
            LoginRequestBody(
                email: credentials.email,
                password: credentials.password,
                deviceId: keychain.get(key: .deviceId) ?? ""
            )
        )
        .map({ $0.toLoginResponse() })
        .mapError({ $0.toCaptureVueError() })
    }
    
    func guestLogin() async -> Result<LoginResponse, CaptureVueError> {
        
        return await authApi.guestLogin(
            GuestLoginRequestBody(
                deviceId: keychain.get(key: .deviceId) ?? ""
            )
        )
        .map({ $0.toLoginResponse() })
        .mapError({$0.toCaptureVueError()})
    }
    
    func updateUsername(_ username: String) async -> Result<UpdateGuestUsernameResponse, CaptureVueError>{
        return await authApi.updateUsername(
            GuestCustomerNameRequest(
                username: username,
                deviceId: keychain.get(key: .deviceId) ?? ""
            )
        )
        .map({ $0.toUpdateGuestUsernameResponse() })
        .mapError({$0.toCaptureVueError()})
    }
    
}
