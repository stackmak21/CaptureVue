//
//  FetchCustomerHomeUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct FetchCustomerHomeUseCase{
    
    private let repository: CustomerRepositoryContract
    
    init(repository: CustomerRepositoryContract) { self.repository = repository }
    
    func invoke(_ token: String) async -> Result<HomeResponse, CaptureVueError> {
        return await repository.fetchHomeContract(token)
    }
}
