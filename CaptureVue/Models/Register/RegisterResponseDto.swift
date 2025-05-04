//
//  RegisterResponseDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/5/25.
//

import Foundation

struct RegisterResponseDto: Codable {
    let token: String?
    let refreshAccessToken: String?
    let customer: CustomerDto?
    
    func toRegisterResponse() -> RegisterResponse{
        return RegisterResponse(
            token: self.token ?? "",
            refreshAccessToken: self.refreshAccessToken ?? "",
            customer: self.customer?.toCustomer() ?? Customer()
        )
    }
}
