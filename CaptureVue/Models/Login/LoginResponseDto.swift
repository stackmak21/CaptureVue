//
//  LoginResponseDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/1/25.
//

import Foundation

struct LoginResponseDto: Codable {
    let token: String?
    
    func toLoginResponse() -> LoginResponse{
        return LoginResponse(token: self.token ?? "")
    }
}


