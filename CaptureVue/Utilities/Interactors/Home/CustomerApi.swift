//
//  CustomerApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct CustomerApi {
    
    private let client: NetworkClient
    private let keychain: KeychainManager = KeychainManager()

    
    init(client: NetworkClient) {
        self.client = client

    }
    
    func fetchCustomerHome() async -> Result<HomeResponseDto, CaptureVueResponseRaw> {
        let token = keychain.get(key: .token) ?? ""
        return await client.execute(
            url: "api/v1/customer/home",
            authToken: token
        )
    }
}
