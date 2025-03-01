//
//  GalleryApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct GalleryApi {
    
    private let client: NetworkClient
    private let fileManager = LocalFileManager.instance
    
    init(client: NetworkClient) { self.client = client }
    
    
    func getAwsDirectUploadUrl(token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrlDto, CaptureVueResponseRaw> {
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
    
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async {
        if let fileData = await fileManager.getFile(fileName: uploadInfo.fileName, folderName: "UploadPendingFiles"){
                let fileLength = String(fileData.count)
                let mimeType = mimeTypeForPath(path: uploadInfo.fileName)
                let eventId = uploadInfo.eventId
                await client.upload(
                    url: uploadUrl,
                    httpMethod: .put,
                    headers: [
                        "Content-Type" : mimeType,
                        "Content-Length" : fileLength,
                        "x-amz-meta-event" : eventId
                    ],
                    requestBody: fileData
                ){
                    print("upload file completed")
                }
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
                "Content-Type" : mimeType,
                "Content-Length" : fileLength,
                "x-amz-meta-event" : eventId
            ],
            requestBody: imageData
        ){
            print("upload thumbnail completed")
        }
    }
    
    
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueResponseRaw {
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


