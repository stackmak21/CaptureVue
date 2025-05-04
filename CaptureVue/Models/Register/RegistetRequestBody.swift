//
//  RegistetRequestBody.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/5/25.
//

import Foundation


struct RegistetRequestBody: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let deviceId: String
    
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
        case email
        case password
        case deviceId
    }
}
