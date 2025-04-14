//
//  CustomerRepository.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct CustomerRepository: CustomerRepositoryContract {
    
    private let customerApi: CustomerApi
    
    init(client: NetworkClient) {
        self.customerApi = CustomerApi(client: client)
    }
    
    func fetchHomeContract() async -> Result<HomeResponse, CaptureVueResponseRaw> {
        return await customerApi.fetchCustomerHome()
            .map({ $0.toHomeResponse() })
            .mapError({ $0 })
    }
    
}
