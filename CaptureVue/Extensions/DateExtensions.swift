//
//  DateExtensions.swift
//  CaptureVue
//
//  Created by Paris Makris on 14/11/24.
//

import Foundation
import SwiftUI


func getCurrentMillis() -> Int64 {
    return Int64(NSDate().timeIntervalSince1970 * 1000)
}

extension Int64 {
    
    var asDate: Date {
        Date(timeIntervalSince1970: Double(self) / 1000)
    }
    
    func asDateString(isShort: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = isShort ? .short : .medium
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self.asDate)
    }
    
    func asTimeString(isShort: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = isShort ? .short : .medium
        return dateFormatter.string(from: self.asDate)
    }
    
    func asTimeStringWithPeriod() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self.asDate)
    }
    
}





extension Date {
    
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    func asDateString(isShort: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = isShort ? .short : .medium
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func asTimeString(isShort: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = isShort ? .short : .medium
        return dateFormatter.string(from: self)
    }
    
    func asTimeStringWithPeriod() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
}
