//
//  CustomerDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct CustomerDto: Codable, Identifiable{
    let id: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let createdAt: Int64?
    let isVerified: Bool?
    let isGuest: Bool?
    
    
    enum CodingKeys: String, CodingKey{
        case id
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case createdAt
        case isVerified
        case isGuest
    }
    
    func toCustomer() -> Customer {
        return Customer(
            id: self.id ?? "",
            email: self.email ?? "",
            firstName: self.firstName ?? "",
            lastName: self.lastName ?? "",
            createdAt: self.createdAt ?? 0,
            isVerified: self.isVerified ?? false
        )
    }
}
