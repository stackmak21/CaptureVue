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
    
    init(client: NetworkClient) {
        self.authApi = AuthApi(client: client)
    }
    

    
    func login(_ credentials: Credentials) async -> LoginResponseResult {
        return await authApi.login(
            LoginRequestBody(
                email: credentials.email,
                password: credentials.password
            )
        )
        .map({ $0.toLoginResponse() })
        .mapError({ $0.toCaptureVueError() })
    }
    
}
