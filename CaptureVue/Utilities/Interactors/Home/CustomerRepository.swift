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
    
    func fetchHomeContract(_ token: String) async -> Result<HomeResponse, CaptureVueError> {
        return await customerApi.fetchCustomerHome(token)
            .map({ $0.toHomeResponse() })
            .mapError({ $0.toCaptureVueError() })
    }
    
}
