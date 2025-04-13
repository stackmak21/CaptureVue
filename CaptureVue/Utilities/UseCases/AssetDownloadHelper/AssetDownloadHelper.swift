//
//  AssetDownloadHelper.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import Foundation
import SwiftUI

class AssetDownloadHelper{
    
    private let downloadAssetUseCase: DownloadAssetUseCase
    private let fileManager: LocalFileManager = LocalFileManager.instance
    
    init(
        client: NetworkClient,
        downloadRepositoryMock: DownloadRepositoryContract? = nil
    ) {
        self.downloadAssetUseCase = DownloadAssetUseCase(client: client, downloadRepositoryMock: downloadRepositoryMock)
    }
    
    func downloadAsset(assetURL: String, assetType: MediaType) async {
        let result = await downloadAssetUseCase.invoke(assetURL: assetURL)
        switch result {
        case .success(let assetData):
            assetType == .photo ? await handleImageData(assetData) : await handleVideoData(assetData)
        case .failure(_):
            print("❌ Asset Download Helper: Failed Downloading Asset ❌")
        }
    }
    
    
    private func handleVideoData(_ videoData: Data) async {
        let folderName = "DownloadPendingFiles"
            let identifier = UUID().uuidString + ".mov"
            await fileManager.saveFile(file: videoData, fileName: identifier, folderName: folderName)
            let videoFilePath = await fileManager.getFileUrl(fileName: identifier, folderName: folderName)
            if let urlPath = videoFilePath{
                let videoSaver = VideoSaver()
                print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 URL PATH:  \(urlPath)")
                await videoSaver.saveVideoToAlbum(videoURL: urlPath, albumName: "Capture Vue")
                if await fileManager.deleteFile(fileName: identifier, folderName: folderName){
                    log.info("Saved video deleted successfully from file manager.")
                    log.success("Thread String", showCurrentThread: true)
                }
            }
            
    }
    
    private func handleImageData(_ photoData: Data) async {
        let imageSaver = ImageSaver()
        await imageSaver.save(photoData: photoData)
        log.success("Photo succesfully saved")
    }
}
