//
//  DownloadApi.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import Foundation


class DownloadApi {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func downloadAsset(assetURL: String) async  -> Result<Data, CaptureVueResponseRaw>{
        let result: Result<Data, CaptureVueResponseRaw> = await client.download(url: assetURL)
        return result
    }

}
