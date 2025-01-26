//
//  LoginInteractor.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/11/24.
//

import Foundation

class LoginInteractor {
    
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func authenticateUser(credentials: Credentials) async throws ->LoginResponseDto? {
        do {
            let response: LoginResponseDto? = try await dataService.authenticate(url: "http://localhost:8090/api/customer/login", credentials: credentials)
                return response
        } catch let error as CaptureVueError {
            throw error
        }
    }
}



