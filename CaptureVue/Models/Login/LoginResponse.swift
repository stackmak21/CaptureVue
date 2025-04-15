//
//  LoginResponse.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/2/25.
//

import Foundation

struct LoginResponse {
    let token: String
    let refreshAccessToken: String
    let customer: Customer
}
