//
//  Credentials.swift
//  CaptureVue
//
//  Created by Paris Makris on 22/1/25.
//
import Foundation

struct Credentials: Codable {
    let email: String
    let password: String
    
    init(
        email: String = "",
        password: String = ""
    ) {
        self.email = email
        self.password = password
    }
    
    func isValid() -> Bool {
        return !email.isEmpty || !password.isEmpty
    }
}
