//
//  GalleryApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation

struct GalleryApi {
    
    private let client: NetworkClient
    
    init(client: NetworkClient) { self.client = client }
    
    func fetchAwsDirectUploadUrl(token: String, eventId: String, section: AssetSectionType.RawValue, filename: String ) async -> Result<AwsDirectUploadUrlDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "/api/v1/gallery/awsDirectUploadUrl",
            authToken: token
        )
    }
}


