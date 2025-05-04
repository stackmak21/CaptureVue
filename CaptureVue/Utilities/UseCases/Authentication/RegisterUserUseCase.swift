//
//  RegisterUserUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/5/25.
//

import Foundation


struct RegisterUserUseCase{
    
    private let repository: AuthRepositoryContract
    
    init(client: NetworkClient, authRepositoryMock: AuthRepositoryContract? = nil) {
        self.repository = authRepositoryMock ?? AuthRepository(client: client)
    }
    
    
    func invoke(_ registerDetails: RegisterDetails) async -> Result<RegisterResponse, CaptureVueError> {
        return await repository.register(registerDetails)
    }
}
