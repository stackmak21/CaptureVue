//
//  RefreshTokenRequestBody.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/4/25.
//

import Foundation


struct RefreshTokenRequestBody: Codable{
    let refreshToken: String
    let deviceId: String
}
