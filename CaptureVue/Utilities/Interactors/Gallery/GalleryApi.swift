//
//  GalleryApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation
import MobileCoreServices

struct GalleryApi {
    
    private let client: NetworkClient
    private let fileManager = LocalFileManager.instance
    
    init(client: NetworkClient) { self.client = client }
    
    func fetchAwsDirectUploadUrl(token: String, eventId: String, section: AssetSectionType, filename: String ) async -> Result<AwsDirectUploadUrlDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "api/v1/gallery/awsDirectUploadUrl",
            authToken: token
        )
    }
 
    
    func getAwsDirectUploadUrl(token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrlDto, CaptureVueErrorDto> {
        return await client.execute(
            url: "api/v1/gallery/awsDirectUploadUrl",
            authToken: token,
            queryItems: [
                "eventId" : uploadInfo.eventId,
                "section" : uploadInfo.section.rawValue,
                "filename" : uploadInfo.fileUrl
            ]
        )
    }
    
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async {
        if let file = await fileManager.getFile(fileUrl: uploadInfo.fileUrl){
            
            let fileLength = String(file.count)
            let mimeType = mimeTypeForPath(path: uploadInfo.fileUrl)
            let eventId = uploadInfo.eventId
            print(file.count.byteSize)
            print("fileLength: " + fileLength + "  Mime Type: " + mimeType + "  EventId: " + eventId)
            await client.upload(
                url: uploadUrl,
                httpMethod: .put,
                headers: [
                    "Content-Type" : mimeType,
                    "Content-Length" : fileLength,
                    "x-amz-meta-event" : eventId
                ],
                fileUrl: uploadInfo.fileUrl
            )
        }
    }
    
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueErrorDto {
        let data = try? JSONEncoder().encode(assetUploadRequest)
        let response: Result<CaptureVueErrorDto, CaptureVueErrorDto> = await client.execute(
            url: "api/v1/gallery/notifyNewAsset",
            authToken: token,
            httpMethod: .post,
            headers: ["Content-Type" : "application/json"],
            requestBody: data
    
        )
        
        switch response {
        case .success(let success):
            return success
        case .failure(let failure):
            print("\(failure.localizedDescription)")
            return CaptureVueErrorDto(msg: nil, code: nil, reason: nil)
        }
        
    }
    
    

    private func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}


