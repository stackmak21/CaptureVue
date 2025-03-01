//
//  CaptureVueError.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/11/24.
//

import Foundation

struct CaptureVueResponseRaw: Codable, Error {
    let msg: String?
    let code: Int?
    let reason: String?
    
    func toCaptureVueError() -> CaptureVueError {
        return CaptureVueError(
            msg: self.msg ?? "",
            code: self.code ?? 0,
            reason: self.reason ?? ""
        )
    }
    
    static let decodeResponseError = CaptureVueResponseRaw(msg: "Capture Vue Error", code: 400, reason: "Reason")
    
}

