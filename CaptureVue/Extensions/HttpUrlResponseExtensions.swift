//
//  HttpUrlResponseExtensions.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/3/25.
//

import Foundation

extension HTTPURLResponse{
    func isSuccess() -> Bool {
        return self.statusCode >= 200 && self.statusCode <= 299
    }
}
