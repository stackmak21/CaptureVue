//
//  GalleryRepositoryContract.swift
//  CaptureVue
//
//  Created by Paris Makris on 20/2/25.
//

import Foundation
import SwiftUI
import PhotosUI

protocol GalleryRepositoryContract {
    func fetchAwsDirectUploadURL(_ token: String, _ uploadInfo: UploadServiceData) async -> Result<AwsDirectUploadUrl, CaptureVueError>
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async -> Void
    func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueError>
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData) async -> Void
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueError
    func prepareUploadFile(file: PhotosPickerItem) async -> (Data, String)
    func getPendingUploadFiles() async -> [String]
    func deleteTempFile(fileName: String) async -> Result<Bool, Never>
    func getThumbnailFromVideo(url: URL, at time: TimeInterval) async -> UIImage?
}
