//
//  LoginInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import Foundation



//MARK: - Type Alias

typealias LoginResponseDtoResult = Result<LoginResponseDto, CaptureVueErrorDto>
typealias LoginResponseResult = Result<LoginResponse, CaptureVueError>

//MARK: - Contract

protocol AuthRepositoryContract {
    func login(_ credentials: Credentials) async -> LoginResponseResult

}

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

class AuthRepositoryMock: AuthRepositoryContract {
    
    
    func login(_ credentials: Credentials) async -> LoginResponseResult {
        return .success(LoginResponse(token: "Test Token"))
    }
    
}

//MARK: - API

class AuthApi {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func login(_ loginRequestBody: LoginRequestBody) async -> LoginResponseDtoResult {
        let requestBody = try? JSONEncoder().encode(loginRequestBody)
        let response: Result<LoginResponseDto, CaptureVueErrorDto> =  await client.execute(
            url: "/api/v1/customer/login",
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: requestBody
        )
        
        return response
    }
}

//MARK: - CredentialsLoginUseCase

struct CredentialsLoginUseCase{
    
    private let repository: AuthRepositoryContract
    
    init(repository: AuthRepositoryContract) {
        self.repository = repository
    }
    
    
    func invoke(_ credentials: Credentials) async -> LoginResponseResult {
        return await repository.login(credentials)
    }
}


