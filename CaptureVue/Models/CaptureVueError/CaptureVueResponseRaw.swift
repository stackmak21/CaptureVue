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
    
    init(
        msg: String? = nil,
        code: Int? = nil,
        reason: String? = nil
    ) {
        self.msg = msg
        self.code = code
        self.reason = reason
    }
    
    func toCaptureVueError() -> CaptureVueError {
        return CaptureVueError(
            msg: self.msg ?? "",
            code: self.code ?? 0,
            reason: self.reason ?? ""
        )
    }
}

