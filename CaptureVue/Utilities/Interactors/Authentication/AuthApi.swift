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
    
    func login(_ loginRequestBody: LoginRequestBody) async -> LoginResponseDtoResult {
        let requestBody = try? JSONEncoder().encode(loginRequestBody)
        let response: Result<LoginResponseDto, CaptureVueResponseRaw> =  await client.execute(
            url: "api/v1/customer/login",
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: requestBody
        )
        
        return response
    }
}
