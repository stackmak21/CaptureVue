//
//  CustomerApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct CustomerApi {
    
    private let client: NetworkClient
    
    init(client: NetworkClient) { self.client = client }
    
    func fetchCustomerHome(_ token: String) async -> Result<HomeResponseDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "api/v1/customer/home",
            authToken: token
        )
    }
}
