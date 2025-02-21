//
//  LoginRequestBody.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/2/25.
//

import Foundation

struct LoginRequestBody: Codable {
    let email: String
    let password: String
}
