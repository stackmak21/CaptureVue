//
//  DataService.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation

let urlPrefix = "http://192.168.1.203:8090/api/v1/"

protocol DataService {
    
    func downloadData<T: Codable>(url fromUrl: String) async throws -> T?
    
}

class DataServiceImpl: DataService {
   
    
    
    
    
    func downloadData<T: Codable>(url fromUrl: String) async throws -> T? {
        do {
            guard let url = URL(string: fromUrl) else { throw NetworkError.badUrlResponse }
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            request.setValue("", forHTTPHeaderField: "Authentication")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse}
            guard response.statusCode >= 200 && response.statusCode < 700 else { throw NetworkError.badStatus }
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
