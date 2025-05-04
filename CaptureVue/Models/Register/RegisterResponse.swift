//
//  RegisterResponse.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/5/25.
//

import Foundation

struct RegisterResponse {
    let token: String
    let refreshAccessToken: String
    let customer: Customer
}
