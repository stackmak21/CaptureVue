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
    
    var onUploadComplete: (() -> Void)? = nil
    var onUploadProgressUpdate: ((Int) -> Void)? = nil
    
    //MARK: - Execute Function
    
    func execute<T: Codable>(
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
    ) async -> Result<T, CaptureVueResponseRaw>{
        do{
            let url = try buildURL(
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
            let serverResponse: T = try handleResponse(data, response)
            return .success(serverResponse)
        }
        catch(let error as CaptureVueResponseRaw){
            return .failure(error)
        }
        catch(let error as NetworkError){
            print(error.errorDescription())
            return .failure(CaptureVueResponseRaw(msg: nil, code: nil, reason: nil))
        }
        catch(let error){
            print(error.localizedDescription)
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
            guard let uploadUrl = URL(string: url) else { throw NetworkError.invalidUrl("") }
            return uploadUrl
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
            request.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
        }
        request.httpBody = requestBody
        return request
    }
    
    //MARK: - HANDLE STATUS CODE RESPONSE
    
    private func handleResponse<T: Codable>(_ data: Data, _ response: URLResponse) throws -> T{
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
        
        if response.isSuccess(){
            if let successResponse = try? JSONDecoder().decode(T.self, from: data) {
                return successResponse
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
                return "Unauthorized"
            case .badUrlResponse:
                return "Bad URL response"
            case .invalidRequest:
                return "Invalid request"
            case .badResponse:
                return "Bad response"
            case .badStatus:
                return "Bad status"
            case .failedToDecodeResponse:
                return "Failed to decode response"
            case .invalidUrl(let error):
                return "Invalid url \(error)"
            case .unknown:
                return "Unknown Error"
            }
        }
        
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
            
            guard let requestBodyData = requestBody else { throw NetworkError.invalidRequest }
            let (_, response) = try await URLSession.shared.upload(for: request, from: requestBodyData, delegate: self)
            guard let urlResponse = response as? HTTPURLResponse, urlResponse.isSuccess() else { throw NetworkError.badResponse  }
            
            
        }
        catch(let error as NetworkError){
            print(error.errorDescription())
        }
        catch(let error){
            print(error.localizedDescription)
        }
    }
}

extension NetworkClient: URLSessionTaskDelegate {

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64) {
            let uploadProgressFloat = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            let uploadProgressInt = Int(uploadProgressFloat * 100)
            onUploadProgressUpdate?(uploadProgressInt)
        }
    
}









