//
//  DownloadRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//

import Foundation


protocol DownloadRepositoryContract{
    func downloadAsset(assetURL: String) async -> Result<Data, CaptureVueError>
}
