////
////  AuthManager.swift
////  CaptureVue
////
////  Created by Paris Makris on 14/4/25.
////
//
//import Foundation
//
//actor AuthManager{
//    private let keychain: KeychainManager = KeychainManager()
//    private let client: NetworkClient = NetworkClient()
//
//    private var currentToken: LoginResponse?
//    private var refreshTask: Task<String, Error>?
//    
//    init(
//        
//    ) {
//        log.warning("Auth Manager INIT")
//    }
//    
//    deinit{
//        log.warning("Auth Manager DE INIT")
//    }
//  
//    
////    func validToken() async throws -> String {
//////        if let handle = refreshTask {
//////            return try await handle.value
//////        }
////
////        guard let token = keychain.get(key: .token) else {
////            throw AuthError.missingAuthToken
////        }
////
////        if token.isEmpty {
////            return token
////        }
////
////        return try await refreshToken()
////    }
////    
////    func refreshToken() async throws -> LoginResponse {
////        if let refreshTask = refreshTask {
////            return try await refreshTask.value
////        }
////
////        let task = Task { () throws -> LoginResponse in
////            defer { refreshTask = nil }
////
////            // Normally you'd make a network call here. Could look like this:
////            // return await networking.refreshToken(withRefreshToken: token.refreshToken)
////            await refreshToken()
////            // I'm just generating a dummy token
//////            let tokenExpiresAt = Date().addingTimeInterval(10)
//////            let newToken = Token(validUntil: tokenExpiresAt, id: UUID())
//////            currentToken = newToken
////
//////            return newToken
////        }
////
////        self.refreshTask = task
////
////        return try await task.value
////    }
//    
//    
//    
//    
//    
//    func refreshToken() async {
//        do{
//            guard let deviceId = keychain.get(key: .deviceId), let refreshToken = keychain.get(key: .refreshToken) else { throw AuthError.missingDeviceId }
//            guard let authToken = keychain.get(key: .token) else { throw AuthError.missingAuthToken }
//            let refreshTokenRequest = RefreshTokenRequestBody(refreshToken: refreshToken, deviceId: deviceId)
//            let requestBody = try? JSONEncoder().encode(refreshTokenRequest)
//            let refreshTokenResponse: Result<LoginResponseDto, CaptureVueResponseRaw> =  await client.execute(
//                url: "api/v1/customer/refreshToken",
//                authToken: authToken,
//                httpMethod: .post,
//                headers: ["Content-Type" : "application/json"],
//                requestBody: requestBody
//            )
//            let refreshResponse = refreshTokenResponse.map({$0.toLoginResponse()})
//            
//            switch refreshResponse{
//            case .success(let response):
//                keychain.save(response.token, key: .token)
//                keychain.save(response.refreshAccessToken, key: .refreshToken)
//            case .failure(let error):
//                throw error
//            }
//        }
//        catch(let error){
//            print("\(#function)", error)
//        }
//    }
//    
////    private func unauthorizedCallRetry<T: Codable>() async throws -> Result<T, CaptureVueResponseRaw> {
////        let url = url.absoluteString
////        guard let authToken = keychain.get(key: .token) else { throw AuthError.missingAuthToken }
////        guard let headers = request.allHTTPHeaderFields else { throw AuthError.failedToGetHeaders }
////        guard let httpMethod = HttpMethod(rawValue: request.httpMethod ?? "") else { throw AuthError.failedToFetchHttpMethod }
////        let serverResponse: Result<T, CaptureVueResponseRaw> = await client.execute(
////            url: url,
////            authToken: authToken,
////            httpMethod: httpMethod,
////            headers: headers,
////            timeInterval: request.timeoutInterval
////
////        )
////        return serverResponse
////    }
//
//    
//    
//
//}
//
//enum AuthError: Error{
//    case missingDeviceId
//    case missingAuthToken
//    case failedToFetchHttpMethod
//    case invalidResponse
//    case decodingFailed
//    case failedToGetHeaders
//}


import Foundation

class AuthManager{
    
    
    let keychain = KeychainManager()
    let client = NetworkClient()
    

        func refreshToken() async {
            do{
                guard let deviceId = keychain.get(key: .deviceId), let refreshToken = keychain.get(key: .refreshToken) else { throw AuthError.missingDeviceId }
                guard let authToken = keychain.get(key: .token) else { throw AuthError.missingAuthToken }
                let refreshTokenRequest = RefreshTokenRequestBody(refreshToken: refreshToken, deviceId: deviceId)
                let requestBody = try? JSONEncoder().encode(refreshTokenRequest)
                let refreshTokenResponse: Result<LoginResponseDto, CaptureVueResponseRaw> =  await client.execute(
                    url: "api/v1/customer/refreshToken",
                    authToken: authToken,
                    httpMethod: .post,
                    headers: ["Content-Type" : "application/json"],
                    requestBody: requestBody
                )
                let refreshResponse = refreshTokenResponse.map({$0.toLoginResponse()})
    
                switch refreshResponse{
                case .success(let response):
                    keychain.save(response.token, key: .token)
                    keychain.save(response.refreshAccessToken, key: .refreshToken)
                case .failure(let error):
                    throw error
                }
            }
            catch(let error){
                log.error(error.localizedDescription)
            }
        }
    
    
    enum AuthError: Error{
        case missingDeviceId
        case missingAuthToken
        case failedToFetchHttpMethod
        case invalidResponse
        case decodingFailed
        case failedToGetHeaders
    }
}
