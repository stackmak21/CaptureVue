//
//  AuthRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

class AuthRepositoryMock: AuthRepositoryContract {
    func guestLogin() async -> Result<LoginResponse, CaptureVueError> {
        .success(LoginResponse(token: "Test Token", refreshAccessToken: "Refresh Token", customer: Customer()))
    }
    
    
    
    func login(_ credentials: Credentials) async -> Result<LoginResponse, CaptureVueError> {
        return .success(LoginResponse(token: "Test Token", refreshAccessToken: "Refresh Token", customer: Customer()))
    }
    
    func register(_ registerDetails: RegisterDetails) async -> Result<RegisterResponse, CaptureVueError>{
        return .success(RegisterResponse(token: "Test Token", refreshAccessToken: "Refresh Token", customer: Customer()))
    }
    
    func updateUsername(_ username: String) async -> Result<UpdateGuestUsernameResponse, CaptureVueError>{
        return .success(UpdateGuestUsernameResponse(guestCustomer: Customer()))
    }
    
}
