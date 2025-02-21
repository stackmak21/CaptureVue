//
//  ValidateEvent.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation

struct ValidateEvent {

    let isValid: Bool
    let expiresAt: Int64
    let startsAt: Int64
    let hasExpired: Bool
    
    init(
        isValid: Bool = false,
        expiresAt: Int64 = 0,
        startsAt: Int64 = 0,
        hasExpired: Bool = true
    ) {
        self.isValid = isValid
        self.expiresAt = expiresAt
        self.startsAt = startsAt
        self.hasExpired = hasExpired
    }
}
