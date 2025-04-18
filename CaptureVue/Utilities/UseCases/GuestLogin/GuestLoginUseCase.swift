//
//  GuestLoginUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 18/4/25.
//

import Foundation

//MARK: - GuestLoginUseCase

struct GuestLoginUseCase{
    
    private let repository: AuthRepositoryContract
    
    init(client: NetworkClient, authRepositoryMock: AuthRepositoryContract? = nil) {
        self.repository = authRepositoryMock ?? AuthRepository(client: client)
    }
    
    
    func invoke() async -> Result<LoginResponse, CaptureVueResponseRaw> {
        return await repository.guestLogin()
    }
}
