//
//  CredentialsLoginUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

//MARK: - CredentialsLoginUseCase

struct CredentialsLoginUseCase{
    
    private let repository: AuthRepositoryContract
    
    init(client: NetworkClient, authRepositoryMock: AuthRepositoryContract? = nil) {
        self.repository = authRepositoryMock ?? AuthRepository(client: client)
    }
    
    
    func invoke(_ credentials: Credentials) async -> Result<LoginResponse, CaptureVueError> {
        return await repository.login(credentials)
    }
}
