//
//  DataService.swift
//  CaptureVue
//
//  Created by Paris Makris on 12/10/24.
//

import Foundation

final class DataService {
    
    
    func downloadData<T: Codable>(fromURL: String) async throws -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrlResponse }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            return decodedResponse
            
        } catch NetworkError.badUrlResponse {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occured downloading the data")
        }
        return nil
    }
    
    enum NetworkError: Error {
        case badUrlResponse
        case invalidRequest
        case badResponse
        case badStatus
        case failedToDecodeResponse
        
    }
    
    func fetchTitle() async throws -> String {
        "Hello, world!"
    }
    
    func fetchSubtitle() async throws -> String {
        throw URLError(.badURL)
    }
    
    func fetchNextScreenTitle() async throws -> String {
        "My next screen!"
    }
}
