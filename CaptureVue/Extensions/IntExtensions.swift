//
//  IntExtensions.swift
//  CaptureVue
//
//  Created by Paris Makris on 25/2/25.
//

import Foundation

extension Int {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}
