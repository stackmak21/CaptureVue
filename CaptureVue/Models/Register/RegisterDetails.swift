//
//  RegisterDetails.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/5/25.
//

import Foundation

struct RegisterDetails: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    
    init(
        firstName: String = "",
        lastName: String = "",
        email: String = "",
        password: String = ""
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
    func isValid() -> Bool {
        return !email.isEmpty || !password.isEmpty
    }
}
