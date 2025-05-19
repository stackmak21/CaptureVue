//
//  UpdateGuestUsernameResponseDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/5/25.
//

import Foundation

struct UpdateGuestUsernameResponseDto: Codable{
    let guestCustomer: CustomerDto?
    
    func toUpdateGuestUsernameResponse() -> UpdateGuestUsernameResponse {
        UpdateGuestUsernameResponse(
            guestCustomer: self.guestCustomer?.toCustomer() ?? Customer()
        )
    }
}

struct UpdateGuestUsernameResponse{
    let guestCustomer: Customer
}
