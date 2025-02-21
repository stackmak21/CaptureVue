//
//  CaptureVueError.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import Foundation

struct CaptureVueError: Error{
    let msg: String
    let code: Int
    let reason: String
}
