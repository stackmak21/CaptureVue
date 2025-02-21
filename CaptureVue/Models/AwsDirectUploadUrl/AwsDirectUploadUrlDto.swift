//
//  AwsDirectUploadUrlDto.swift
//  CaptureVue
//
//  Created by Paris Makris on 6/2/25.
//

import Foundation


struct AwsDirectUploadUrlDto: Codable {
    let url: String?
    
    func toAwsDirectUploadUrl() -> AwsDirectUploadUrl {
        AwsDirectUploadUrl(url: self.url ?? "")
    }
}
