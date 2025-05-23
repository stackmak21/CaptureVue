//
//  Customer.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct Customer: Codable {
    
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let createdAt: Int64
    let isVerified: Bool
    let isGuest: Bool
    let password: String
    
    init(
        id: String = "",
        email: String = "",
        firstName: String = "",
        lastName: String = "",
        createdAt: Int64 = 0,
        isVerified: Bool = false,
        isGuest: Bool = false,
        password: String = ""
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.createdAt = createdAt
        self.isVerified = isVerified
        self.isGuest = isGuest
        self.password = password
    }
}
