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
    func copyIntoTempFile(_ selectedFile: Data, identifier: String) async -> Void
    func getAwsDirectUploadUrl(_ token: String, uploadInfo: PrepareUploadData) async -> Result<AwsDirectUploadUrl, CaptureVueResponseRaw>
    func uploadAwsFile(uploadUrl: String, uploadInfo: PrepareUploadData, onUploadProgressUpdate: ((Int) -> Void)?) async -> Void
    func notifyNewAssetUpload(_ token: String, assetUploadRequest: NotifyNewAssetRequest) async -> CaptureVueResponseRaw
    func prepareUploadFile(file: PhotosPickerItem) async -> (Data, String)
    func getPendingUploadFiles() async -> [String]
    func deleteTempFile(fileName: String) async -> Bool
    func getThumbnailFromVideo(url: URL, at time: TimeInterval) async -> UIImage?
    func uploadAwsThumbnail(uploadUrl: String, uploadInfo: PrepareUploadData, imageData: Data) async
    func prepareUploadCameraFile(file: CameraAsset) async -> (Data, String)
}
