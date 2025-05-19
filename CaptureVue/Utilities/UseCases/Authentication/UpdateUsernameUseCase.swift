//
//  UpdateUsernameUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/5/25.
//

import Foundation

struct UpdateUsernameUseCase{
    
    private let repository: AuthRepositoryContract
    
    init(client: NetworkClient, authRepositoryMock: AuthRepositoryContract? = nil) {
        self.repository = authRepositoryMock ?? AuthRepository(client: client)
    }
    
    func invoke(_ username: String) async -> Result<UpdateGuestUsernameResponse, CaptureVueError> {
        return await repository.updateUsername(username)
    }
}
