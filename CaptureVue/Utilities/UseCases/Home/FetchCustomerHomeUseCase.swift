//
//  FetchCustomerHomeUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct FetchCustomerHomeUseCase{
    
    private let repository: CustomerRepositoryContract
    
    init(client: NetworkClient, customerRepositoryMock: CustomerRepositoryContract? = nil) {
        self.repository = customerRepositoryMock ?? CustomerRepository(client: client)
    }
    
    func invoke() async -> Result<HomeResponse, CaptureVueResponseRaw> {
        return await repository.fetchHomeContract()
    }
}
