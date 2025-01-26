//
//  DataService.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation
import SwiftUI

let urlPrefix = "http://localhost:8090/api/v1"

protocol DataService {
    
    func downloadData<T: Codable>(url fromUrl: String, authToken: String) async throws -> T?
    
    func authenticate<T: Codable>(url fromUrl: String, credentials: Credentials) async throws -> T?
    
    func uploadPhoto<T: Codable>(url fromUrl: String, createEventRequest: CreateEventRequest, imageData: Data?, authToken: String) async throws -> T?
    
}

class DataServiceImpl: DataService {
    
    func downloadData<T: Codable>(url fromUrl: String, authToken: String) async throws -> T? {
        do {
            guard let url = URL(string: fromUrl) else { throw NetworkError.badUrlResponse }
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            //            request.setValue("", forHTTPHeaderField: "Authentication")
            request.addValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
            guard response.statusCode >= 200 && response.statusCode < 700 else { throw NetworkError.badStatus }
            if let successResponse = try? JSONDecoder().decode(T.self, from: data) {
                return successResponse
            }
            if let errorResponse = try? JSONDecoder().decode(CaptureVueError.self, from: data) {
                throw errorResponse
            } else{
                throw NetworkError.failedToDecodeResponse
            }
        }
        catch(let error as CaptureVueError){
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
    
    func authenticate<T: Codable>(url fromUrl: String, credentials: Credentials) async throws -> T? {
        do {
            guard let url = URL(string: fromUrl) else { throw NetworkError.badUrlResponse }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            do {
                let requestBody = try JSONEncoder().encode(credentials)
                request.httpBody = requestBody
            } catch {
                print("Failed to encode credentials: \(error)")
                throw NetworkError.invalidRequest
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
            guard response.statusCode >= 200 && response.statusCode < 700 else { throw NetworkError.badStatus }
            if let successResponse = try? JSONDecoder().decode(T.self, from: data) {
                return successResponse
            }
            if let errorResponse = try? JSONDecoder().decode(CaptureVueError.self, from: data) {
                throw errorResponse
            } else{
                throw NetworkError.failedToDecodeResponse
            }
        }
        catch(let error as CaptureVueError){
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
            if let imageData{
                print("imageData 🔥")
                body.append("Content-Disposition: form-data; name=\"eventImage\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
                
                // Final boundary
               
            }
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
            if let errorResponse = try? JSONDecoder().decode(CaptureVueError.self, from: data) {
                throw errorResponse
            } else{
                throw NetworkError.failedToDecodeResponse
            }
        }
        catch(let error as CaptureVueError){
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

}

enum NetworkError: Error {
    case badUrlResponse
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
    
    func errorDescription() -> String {
        switch self {
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
        }
    }
    
}
