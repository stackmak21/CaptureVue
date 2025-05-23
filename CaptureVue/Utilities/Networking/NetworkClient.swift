//
//  DataService.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation
import SwiftUI


class NetworkClient: NSObject {
    //MARK: - URL DETAILS
    
    private let scheme: URLScheme = .http
    private let host = "128.140.3.193"
    private let port = 8090
    
    private let keychain: KeychainManager = KeychainManager()
    
    var onUploadComplete: (() -> Void)? = nil
    var onUploadProgressUpdate: ((Int) -> Void)? = nil
    
    //MARK: - Execute Function
    
    func execute<T: Codable>(
        url endpoint: String = "",
        authToken: String = "",
        queryItems: [String: String] = [:],
        urlScheme: URLScheme? = nil,
        urlHost: String? = nil,
        urlPort: Int? = nil,
        httpMethod: HttpMethod = .get,
        headers: [String: String] = [:],
        timeInterval: Double = 60,
        requestBody: Data? = nil,
        urlRequest: URLRequest? = nil,
        retrying: Bool = false
    ) async -> Result<T, CaptureVueResponseRaw> {
        do {
            let request: URLRequest
            if let providedRequest = urlRequest {
                request = providedRequest
            } else {
                let url = try buildURL(
                    scheme: urlScheme ?? scheme,
                    host: urlHost ?? host,
                    port: urlPort ?? port,
                    endpoint: endpoint,
                    queryItems: queryItems
                )

                request = buildRequest(
                    url: url,
                    httpMethod: httpMethod,
                    headers: headers,
                    timeInterval: timeInterval,
                    requestBody: requestBody,
                    authToken: authToken
                )
            }
            NetworkLogger.log(request: request)
            let (data, response) = try await URLSession.shared.data(for: request)
            let successResponse: Result<T, CaptureVueResponseRaw> = try await handleResponse(data, response, request, retrying)
            return successResponse

        } catch let error as CaptureVueResponseRaw {
            return .failure(error)
        } catch let error as NetworkError {
            log.error(error.errorDescription())
            return .failure(CaptureVueResponseRaw(msg: error.errorDescription(), code: nil, reason: nil))
        } catch {
            log.error(error.localizedDescription)
            return .failure(CaptureVueResponseRaw(msg: error.localizedDescription, code: nil, reason: nil))
        }
    }
    
    //MARK: - HANDLE  RESPONSE
    
    private func handleResponse<T: Codable>(_ data: Data, _ response: URLResponse, _ urlRequest: URLRequest, _ retry: Bool) async throws -> Result<T, CaptureVueResponseRaw>{
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
        
        NetworkLogger.log(response: response, data: data, error: nil)
        
        if response.isUnauthorized{
            if !retry{
                let authToken = await refreshToken()
                var request = urlRequest
                request.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
                return await execute(urlRequest: request, retrying: true)  // <----- Recursive function called after refreshing token.
            }
            else{
                throw NetworkError.unauthorized
            }
        }
        
        if response.isSuccess{
            if let successResponse = try? JSONDecoder().decode(T.self, from: data) {
                return .success(successResponse)
            }else{
                throw NetworkError.failedToDecodeResponse
            }
        }
        
        switch response.statusCode {
        case 401, 451:
            if let errorResponse = try? JSONDecoder().decode(CaptureVueResponseRaw.self, from: data) {
                throw errorResponse
            }
        case 400...599:
            if let errorResponse = try? JSONDecoder().decode(CaptureVueResponseRaw.self, from: data) {
                throw errorResponse
            }
        default:
            throw NetworkError.unknown
        }
        throw NetworkError.unknown
    }

    
    func refreshToken() async -> String {
        do{
            guard let deviceId = keychain.get(key: .deviceId), let refreshToken = keychain.get(key: .refreshToken) else { throw AuthError.missingDeviceId }
            guard let authToken = keychain.get(key: .token) else { throw AuthError.missingAuthToken }
            let refreshTokenRequest = RefreshTokenRequestBody(refreshToken: refreshToken, deviceId: deviceId)
            let requestBody = try? JSONEncoder().encode(refreshTokenRequest)
            let refreshTokenResponse: Result<LoginResponseDto, CaptureVueResponseRaw> =  await execute(
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
                return response.token
            case .failure(let error):
                throw error
            }
        }
        catch(let error){
            log.error(error.localizedDescription)
            return ""
        }
    }
    
    
    func download(
        url endpoint: String,
        authToken: String = "",
        queryItems: [String: String] = [:],
        urlScheme: URLScheme? = nil,
        urlHost: String? = nil,
        urlPort: Int? = nil,
        httpMethod: HttpMethod = .get,
        headers: [String: String] = [:],
        timeInterval: Double = 60,
        requestBody: Data? = nil
    ) async -> Result<Data, CaptureVueResponseRaw>{
        do{
            let url = try buildURL(
                url: endpoint.hasPrefix("http") ? endpoint : nil,
                scheme: urlScheme ?? scheme,
                host: urlHost ?? host,
                port: urlPort ?? port,
                endpoint: endpoint,
                queryItems: queryItems
            )
            
            let request = buildRequest(
                url: url,
                httpMethod: httpMethod,
                headers: headers,
                timeInterval: timeInterval,
                requestBody: requestBody,
                authToken: authToken
            )
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
            if response.isSuccess{
                return .success(data)
            }else{
                throw NetworkError.badResponse
            }
            
        }
        catch(let error as CaptureVueResponseRaw){
            log.error(error.msg ?? error.localizedDescription)
            return .failure(error)
        }
        catch(let error as NetworkError){
            log.error(error.errorDescription())
            return .failure(CaptureVueResponseRaw(msg: nil, code: nil, reason: nil))
        }
        catch(let error){
            log.error(error.localizedDescription)
            return .failure(CaptureVueResponseRaw(msg: nil, code: nil, reason: nil))
        }
    }
    
    
    
    //MARK: - BUILD URL FUNCTION
    
    private func buildURL(
        url completedUrl: String? = nil,
        scheme: URLScheme = .http,
        host: String = "",
        port: Int? = nil,
        endpoint path: String = "",
        queryItems: [String: String] = [:]
        
    ) throws -> URL {
        if let url = completedUrl{
            guard let prefixedURL = URL(string: url) else { throw NetworkError.invalidUrl("") }
            return prefixedURL
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        if path.hasPrefix("/"){ throw NetworkError.invalidUrl("propably due to '/' in the beginning of the endpoint.") }
        let fixedPath = "/\(path)"
        urlComponents.path = fixedPath
        urlComponents.port = port
        var queryItemsArray: [URLQueryItem] = []
        queryItems.forEach({queryItemsArray.append(URLQueryItem(name: $0, value: $1))})
        urlComponents.queryItems = queryItemsArray
        guard let url = urlComponents.url else { throw NetworkError.invalidUrl("") }
        return url
    }
    
    //MARK: - BUILD REQUEST FUNCTION\
    
    private func buildRequest(
        url: URL,
        httpMethod: HttpMethod? = nil,
        headers: [String: String] = [:],
        timeInterval: Double,
        requestBody: Data? = nil,
        authToken: String = ""
    ) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: timeInterval)
        request.httpMethod = httpMethod?.rawValue
        headers.forEach({request.setValue($1, forHTTPHeaderField: $0)})
        if !authToken.isEmpty{
            request.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        }
        request.httpBody = requestBody
        return request
    }
    

    
    //MARK: - Upload Function
    
    func upload(
        url endpoint: String,
        authToken: String = "",
        queryItems: [String: String] = [:],
        urlScheme: URLScheme? = nil,
        urlHost: String? = nil,
        urlPort: Int? = nil,
        httpMethod: HttpMethod = .get,
        headers: [String: String] = [:],
        timeInterval: Double = 60,
        requestBody: Data? = nil,
        onUploadProgressUpdate: ((Int) -> Void)? = nil ,
        onUploadComplete: (() -> Void)? = nil
        
    ) async {
        do{
            let url = try buildURL(
                url: endpoint.hasPrefix("http") ? endpoint : nil,
                scheme: urlScheme ?? scheme,
                host: urlHost ?? host,
                port: urlPort ?? port,
                endpoint: endpoint,
                queryItems: queryItems
            )
            let request = buildRequest(
                url: url,
                httpMethod: httpMethod,
                headers: headers,
                timeInterval: timeInterval,
                authToken: authToken
            )
            
            self.onUploadComplete = onUploadComplete
            self.onUploadProgressUpdate = onUploadProgressUpdate
            
            if let byteCount = requestBody?.count{ // replace with data.count
                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                bcf.countStyle = .file
                let string = bcf.string(fromByteCount: Int64(byteCount))
                log.warning("Data SIZE: \(string)")
            }
            
            let uploadProgressHandler = UploadProgressHandler(onProgressChange: onUploadProgressUpdate)
            
            guard let requestBodyData = requestBody else { throw NetworkError.invalidRequest }
            let (_, response) = try await URLSession.shared.upload(for: request, from: requestBodyData, delegate: uploadProgressHandler)
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.isSuccess else { throw NetworkError.badResponse  }
            
            
        }
        catch(let error as NetworkError){
            log.error(error.errorDescription())
        }
        catch(let error){
            log.error(error.localizedDescription)
        }
    }
    
}

class UploadProgressHandler: NSObject, URLSessionTaskDelegate {
    
    let onProgressChange: ((Int) -> Void)?
    
    init(
        onProgressChange: ((Int) -> Void)? = nil
    ){
        self.onProgressChange = onProgressChange
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64){
            log.error("URL SESSION DATA EXECUTED", showCurrentThread: true)
            let uploadProgressFloat = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            let uploadProgressInt = Int(uploadProgressFloat * 100)
            onProgressChange?(uploadProgressInt)
        }
}




enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum URLScheme: String {
    case http = "http"
    case https = "https"
}


enum NetworkError: Error {
    case unknown
    case unauthorized
    case badUrlResponse
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
    case invalidUrl(_ errorDescription: String)
    
    func errorDescription() -> String {
        switch self {
        case .unauthorized:
            return "Unauthorized."
        case .badUrlResponse:
            return "Bad URL response."
        case .invalidRequest:
            return "Invalid request."
        case .badResponse:
            return "Bad response."
        case .badStatus:
            return "Bad status."
        case .failedToDecodeResponse:
            return "Failed to decode response."
        case .invalidUrl(let error):
            return "Invalid url \(error)."
        case .unknown:
            return "Unknown Error."
        }
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
