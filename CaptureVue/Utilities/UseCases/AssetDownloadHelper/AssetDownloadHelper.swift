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
        log.info(assetURL)
        let assetName = NSString(string: assetURL).lastPathComponent
        let result = await downloadAssetUseCase.invoke(assetURL: assetURL)
        switch result {
        case .success(let assetData):
            assetType == .photo ? await handleImageData(assetData) : await handleVideoData(assetData, assetName)
        case .failure(_):
            log.error("Failed downloading asset.")
        }
    }
    
    
    private func handleVideoData(_ videoData: Data, _ assetName: String) async {
        let folderName = Constants.Folders.downloadFolder
        if let url = await fileManager.saveFile(file: videoData, fileName: assetName, folderName: folderName){
            let assetSaver = AssetSaver()
            await assetSaver.saveVideo(videoURL: url, albumName: "All Photos") // <------- Change here accordingly to which Album we choose
            if await fileManager.deleteFile(fileName: assetName, folderName: folderName){
                log.info("Saved video deleted successfully from temporary folder.")
            }
        }
    }
    
    private func handleImageData(_ photoData: Data) async {
        let assetSaver = AssetSaver()
        await assetSaver.savePhoto(photoData: photoData, albumName: "All Photos") // <------- Change here accordingly to which Album we choose
    }
}
