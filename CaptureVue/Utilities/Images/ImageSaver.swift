//
//  ImageSaver.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/4/25.
//

import Foundation
import SwiftUI
import Photos


class ImageSaver{
    
    var isPhotoLibraryReadWriteAccessGranted: Bool {
        get async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            // Determine if the user previously authorized read/write access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            }
            
            return isAuthorized
        }
    }

    func save(photoData: Data) async {
        // Confirm the user granted read/write access.
        guard await isPhotoLibraryReadWriteAccessGranted else { return }
        
        await withCheckedContinuation { continuation in
            
            PHPhotoLibrary.shared().performChanges {
                // Save the photo data.
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            } completionHandler: { success, error in
                if let error {
                    print("Error saving photo: \(error.localizedDescription)")
                }
                continuation.resume()
            }
            
        }
    }
}
