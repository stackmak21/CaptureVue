//
//  AuthApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

//MARK: - API

class AuthApi {
    
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func register(_ registerRequestBody: RegistetRequestBody) async -> Result<RegisterResponseDto, CaptureVueResponseRaw>{
        let requestBody = try? JSONEncoder().encode(registerRequestBody)
        let response: Result<RegisterResponseDto, CaptureVueResponseRaw> =  await client.execute(
            url: "api/v1/customer/register",
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: requestBody
        )
        return response
    }
    
    func login(_ loginRequestBody: LoginRequestBody) async -> Result<LoginResponseDto, CaptureVueResponseRaw> {
        let requestBody = try? JSONEncoder().encode(loginRequestBody)
        let response: Result<LoginResponseDto, CaptureVueResponseRaw> =  await client.execute(
            url: "api/v1/customer/login",
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: requestBody
        )
        return response
    }
    
    
    func guestLogin(_ guestLoginRequestBody: GuestLoginRequestBody) async -> Result<LoginResponseDto, CaptureVueResponseRaw> {
        let requestBody = try? JSONEncoder().encode(guestLoginRequestBody)
        let response: Result<LoginResponseDto, CaptureVueResponseRaw> =  await client.execute(
            url: "api/v1/customer/guest",
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: requestBody
        )
        return response
    }
    
    
    func refreshToken(_ refreshTokenRequestBody: RefreshTokenRequestBody) async -> Result<LoginResponseDto ,CaptureVueResponseRaw> {
        let requestBody = try? JSONEncoder().encode(refreshTokenRequestBody)
        let response: Result<LoginResponseDto, CaptureVueResponseRaw> =  await client.execute(
            url: "api/v1/customer/refreshToken",
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: requestBody
        )
        return response
    }
    
    func updateUsername(_ updateUsernameRequest: GuestCustomerNameRequest) async -> Result<UpdateGuestUsernameResponseDto, CaptureVueResponseRaw> {
        let requestBody = try? JSONEncoder().encode(updateUsernameRequest)
        let response: Result<UpdateGuestUsernameResponseDto, CaptureVueResponseRaw> =  await client.execute(
            url: "api/v1/customer/updateGuestName",
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: requestBody
        )
        return response
    }
}
