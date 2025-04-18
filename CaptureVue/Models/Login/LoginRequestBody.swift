//
//  LoginRequestBody.swift
//  CaptureVue
//
//  Created by Paris Makris on 19/2/25.
//

import Foundation
import SwiftUI

struct LoginRequestBody: Codable {
    let email: String
    let password: String
    let deviceId: String 
}


struct GuestLoginRequestBody: Codable {
    let deviceId: String
}
