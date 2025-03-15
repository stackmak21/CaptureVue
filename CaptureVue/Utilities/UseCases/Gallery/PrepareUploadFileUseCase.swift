//
//  PrepareUploadFileUseCase.swift
//  CaptureVue
//
//  Created by Paris Makris on 26/2/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct PrepareUploadFileUseCase{
    
    private let repository: GalleryRepositoryContract
    
    init(client: NetworkClient, galleryRepositoryMock: GalleryRepositoryContract? = nil) {
        self.repository = galleryRepositoryMock ?? GalleryRepository(client: client)
    }
    
    func invokeLibraryAsset(_ selectedFile: PhotosPickerItem) async -> (Data, String) {
        return await repository.prepareUploadFile(file: selectedFile)
    }
    
    func invokeCameraAsset(_ selectedFile: CameraAsset) async -> (Data, String) {
        return await repository.prepareUploadCameraFile(file: selectedFile)
    }
}

enum CameraAsset {
    case image(UIImage)
    case video(AVAsset)
}
