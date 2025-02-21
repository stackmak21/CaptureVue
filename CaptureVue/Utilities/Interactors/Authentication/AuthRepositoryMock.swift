//
//  AuthRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

class AuthRepositoryMock: AuthRepositoryContract {
    
    
    func login(_ credentials: Credentials) async -> LoginResponseResult {
        return .success(LoginResponse(token: "Test Token"))
    }
    
}
