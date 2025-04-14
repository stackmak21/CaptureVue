//
//  GalleryApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers



enum Headers: String{
    case contentType = "Content-Type"
    case contentLength = "Content-Length"
    case xAmzMetaEvent = "x-amz-meta-event"
    
}

struct GalleryApi {
    
    private let client: NetworkClient
    private let fileManager = LocalFileManager.instance
    private let keychain: KeychainManager = KeychainManager()
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    
    func getAwsDirectUploadUrl(uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrlDto, CaptureVueResponseRaw> {
        let token = keychain.get(key: .token) ?? ""
        return await client.execute(
            url: "api/v1/gallery/awsDirectUploadUrl",
            authToken: token,
            queryItems: [
                "eventId" : uploadInfo.eventId,
                "section" : uploadInfo.section.rawValue,
                "filename" : uploadInfo.fileName
            ]
        )
    }
    
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData, onUploadProgressUpdate: ((Int) -> Void)? = nil) async {
        if let fileData = await fileManager.getFile(fileName: uploadInfo.fileName, folderName: "UploadPendingFiles"){
                let fileLength = String(fileData.count)
                log.warning("Data SIZE LENGTH: \(fileLength)")
                let mimeType = mimeTypeForPath(path: uploadInfo.fileName)
                let eventId = uploadInfo.eventId
                await client.upload(
                    url: uploadUrl,
                    httpMethod: .put,
                    headers: [
                        Headers.contentType.rawValue : mimeType,
                        Headers.contentLength.rawValue : fileLength,
                        Headers.xAmzMetaEvent.rawValue : eventId
                    ],
                    requestBody: fileData,
                    onUploadProgressUpdate: { onUploadProgressUpdate?($0) },
                    onUploadComplete: {}
                )
        }
    }
    
    func uploadAwsThumbnail(uploadUrl: String, uploadInfo: PrepareUploadData, imageData: Data) async {
        let fileLength = String(imageData.count)
        let mimeType = mimeTypeForPath(path: uploadInfo.fileName)
        let eventId = uploadInfo.eventId
        await client.upload(
            url: uploadUrl,
            httpMethod: .put,
            headers: [
                Headers.contentType.rawValue : mimeType,
                Headers.contentLength.rawValue : fileLength,
                Headers.xAmzMetaEvent.rawValue : eventId
            ],
            requestBody: imageData
        )
        
    }
    
    
    func notifyNewAssetUpload(assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueResponseRaw {
        let token = keychain.get(key: .token) ?? ""
        let data = try? JSONEncoder().encode(assetUploadRequest)
        let response: Result<CaptureVueResponseRaw, CaptureVueResponseRaw> = await client.execute(
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
            return CaptureVueResponseRaw(msg: nil, code: nil, reason: nil)
        }
        
    }
    
    
    
    private func mimeTypeForPath(path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        if let uti = UTType(filenameExtension: pathExtension),
           let mimeType = uti.preferredMIMEType {
            return mimeType
        }
        return "application/octet-stream"
    }
}


