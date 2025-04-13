//
//  DownloadRepositoryMock.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import Foundation

class DownloadRepositoryMock: DownloadRepositoryContract{
    
    func downloadAsset(assetURL: String) async -> Result<Data, CaptureVueError>{
        return .success(Data.empty)
    }
}
