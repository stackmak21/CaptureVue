//
//  DownloadRepository.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import Foundation


class DownloadRepository: DownloadRepositoryContract{
 
    private let downloadApi: DownloadApi
    
    init(client: NetworkClient) {
        self.downloadApi = DownloadApi(client: client)
    }
    
    func downloadAsset(assetURL: String) async -> Result<Data, CaptureVueError> {
        return await downloadApi.downloadAsset(
            assetURL: assetURL
        )
        .mapError({$0.toCaptureVueError()})
    }
}
