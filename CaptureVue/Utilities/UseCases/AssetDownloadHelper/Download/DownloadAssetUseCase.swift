//
//  DownloadAssetUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import Foundation


struct DownloadAssetUseCase{
    
    private let repository: DownloadRepositoryContract
    
    init(client: NetworkClient, downloadRepositoryMock: DownloadRepositoryContract? = nil) {
        self.repository = downloadRepositoryMock ?? DownloadRepository(client: client)
    }
    
    func invoke(assetURL: String) async -> Result<Data, CaptureVueError> {
        return await repository.downloadAsset(assetURL: assetURL)
    }
    
    
}
