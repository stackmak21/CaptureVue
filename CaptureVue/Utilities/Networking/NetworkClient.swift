//
//  DataService.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation
import SwiftUI

extension HTTPURLResponse{
    func isSuccess() -> Bool {
        return self.statusCode >= 200 && self.statusCode <= 299
    }
}



class NetworkClient: NSObject {
    //MARK: - URL DETAILS

    private let scheme: URLScheme = .http
    private let host = "128.140.3.193"
    private let port = 8090
    

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
    ) async -> Result<T, CaptureVueErrorDto>{
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
        catch(let error as CaptureVueErrorDto){
            return .failure(error)
        }
        catch(let error as NetworkError){
            print(error.errorDescription())
            return .failure(CaptureVueErrorDto(msg: nil, code: nil, reason: nil))
        }
        catch(let error){
            print(error.localizedDescription)
            return .failure(CaptureVueErrorDto(msg: nil, code: nil, reason: nil))
        }
    }
    
    
    //MARK: - BUILD URL FUNCTION
    
    private func buildURL(
        scheme: URLScheme = .http,
        host: String = "",
        port: Int? = nil,
        endpoint path: String = "",
        queryItems: [String: String] = [:]
        
    ) throws -> URL {
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
        request.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
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
            if let errorResponse = try? JSONDecoder().decode(CaptureVueErrorDto.self, from: data) {
                throw errorResponse
            }
        case 400...599:
            if let errorResponse = try? JSONDecoder().decode(CaptureVueErrorDto.self, from: data) {
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

    

    func uploadPhoto<T: Codable>(url fromUrl: String, createEventRequest: CreateEventRequest, imageData: Data?, authToken: String) async throws -> T? {
        do {
            guard let url = URL(string: fromUrl) else { throw NetworkError.badUrlResponse }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            request.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            
            
            var body = Data()
            
            // Add JSON part
            if let jsonData = try? JSONEncoder().encode(createEventRequest) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"createEventRequest\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
                body.append(jsonData)
                body.append("\r\n".data(using: .utf8)!)
            }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            // Add file part
            
            body.append("Content-Disposition: form-data; name=\"eventImage\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            if let imageData{
                body.append(imageData)
            }
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            
            request.httpBody = body
            
            print(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
            guard response.statusCode >= 200 && response.statusCode < 700 else { throw NetworkError.badStatus }
            print(data)
            if let successResponse = try? JSONDecoder().decode(T.self, from: data) {
                return successResponse
            }
            if let errorResponse = try? JSONDecoder().decode(CaptureVueErrorDto.self, from: data) {
                throw errorResponse
            } else{
                throw NetworkError.failedToDecodeResponse
            }
        }
        catch(let error as CaptureVueErrorDto){
            throw error
        }
        catch (let error as NetworkError){
            print(error.errorDescription())
        }
        catch{
            print("Uknown Error ⚠️⚠️⚠️⚠️⚠️")
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
//    func downloadData<T: Codable>(url fromUrl: String, authToken: String) async throws -> T? {
//        do {
//            guard let url = URL(string: "\(urlPrefix)\(fromUrl)") else { throw NetworkError.invalidUrl }
//            var request = URLRequest(url: url)
//
//            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
//            //            request.setValue("", forHTTPHeaderField: "Authentication")
//            request.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
//
//
//            let (data, response) = try await URLSession.shared.data(for: request)
//            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
//            guard response.statusCode >= 200 && response.statusCode < 700 else { throw NetworkError.badStatus }
//            if let successResponse = try? JSONDecoder().decode(T.self, from: data) {
//                return successResponse
//            }
//            if let errorResponse = try? JSONDecoder().decode(CaptureVueErrorDto.self, from: data) {
//                throw errorResponse
//            } else{
//                throw NetworkError.failedToDecodeResponse
//            }
//        }
//        catch(let error as CaptureVueErrorDto){
//            throw error
//        }
//        catch (let error as NetworkError){
//            print(error.errorDescription())
//        }
//        catch{
//            print("Uknown Error ⚠️⚠️⚠️⚠️⚠️")
//        }
//
//        return nil
//    }
//
//    func authenticate<T: Codable>(url fromUrl: String, credentials: Credentials) async -> Result<T, Error> {
//        do {
//            guard let url = URL(string: fromUrl) else { throw NetworkError.badUrlResponse }
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
//            do {
//                let requestBody = try JSONEncoder().encode(credentials)
//                request.httpBody = requestBody
//            } catch {
//                print("Failed to encode credentials: \(error)")
//                throw NetworkError.invalidRequest
//            }
//
//            let (data, response) = try await URLSession.shared.data(for: request)
//            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
//            guard response.statusCode >= 200 && response.statusCode < 700 else { throw NetworkError.badStatus }
//            if let successResponse = try? JSONDecoder().decode(T.self, from: data) {
//                return .success(successResponse)
//            }
//            if let errorResponse = try? JSONDecoder().decode(CaptureVueErrorDto.self, from: data) {
//                return .failure(errorResponse)
//            } else{
//                throw NetworkError.failedToDecodeResponse
//            }
//        }
//        catch(let error as CaptureVueErrorDto){
//            return .failure(error)
//        }
//        catch (let error as NetworkError){
//            print(error.errorDescription())
//        }
//        catch{
//            print("Uknown Error ⚠️⚠️⚠️⚠️⚠️")
//        }
//    }
//
    
}

extension NetworkClient: URLSessionTaskDelegate {

    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64) {
        
        print("fractionCompleted  : \(Int(Float(totalBytesSent) / Float(totalBytesExpectedToSend) * 100))")
            
    }
}









