//
//  ValidateEventDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/11/24.
//

import Foundation

struct ValidateEventDto: Codable{
    var isValid: Bool?
    var expiresAt: Int64?
    var startsAt: Int64?
    var hasExpired: Bool?
    
    func toValidateEvent() -> ValidateEvent{
        return ValidateEvent(
            isValid: self.isValid ?? false,
            expiresAt: self.expiresAt ?? 0,
            startsAt: self.startsAt ?? 0,
            hasExpired: self.hasExpired ?? true
        )
    }
}



