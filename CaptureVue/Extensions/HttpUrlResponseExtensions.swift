//
//  HttpUrlResponseExtensions.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/3/25.
//

import Foundation

extension HTTPURLResponse{
    var isSuccess: Bool {
        return self.statusCode >= 200 && self.statusCode <= 299
    }
    
    var isUnauthorized: Bool {
        return self.statusCode == 401
    }
}
