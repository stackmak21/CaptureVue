//
//  ValidateEvent.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/11/24.
//


struct ValidateEventDto: Codable{
    var isValid: Bool
    var expiresAt: Int64
    var startsAt: Int64
    var hasExpired: Bool
}
