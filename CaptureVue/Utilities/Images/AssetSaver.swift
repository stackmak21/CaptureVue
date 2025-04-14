//
//  AssetSaver.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//


import UIKit
import Photos

class AssetSaver: NSObject {
    
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
    
    //MARK: - Photo Saver
    func savePhoto(photoData: Data, albumName: String) async {
        // Confirm the user granted read/write access.
        guard await isPhotoLibraryReadWriteAccessGranted else { return }
        
        if albumExists(albumName: albumName) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let album = collection.firstObject {
                await savePhotoToAlbum(photoData: photoData, to: album)
            }
        }
        else {
            if let album = await createAlbum(albumName: albumName){
                await savePhotoToAlbum(photoData: photoData, to: album)
            }
        }
    }
    
    private func savePhotoToAlbum(photoData: Data, to album: PHAssetCollection) async {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let enumeration: NSArray = [creationRequest.placeholderForCreatedAsset!]
                albumChangeRequest?.addAssets(enumeration)
            } completionHandler: { success, error in
                if let error {
                    log.error("Error saving photo.")
                }
                log.success("Photo saved succesfully.")
                continuation.resume()
            }
            
        }
    }
    
    //MARK: - Video Saver
    func saveVideo(videoURL: URL, albumName: String) async {
        if albumExists(albumName: albumName) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let album = collection.firstObject {
                await saveVideoToAlbum(videoURL: videoURL, to: album)
            }
        }
        else {
            if let album = await createAlbum(albumName: albumName){
                await saveVideoToAlbum(videoURL: videoURL, to: album)
            }
        }
    }
    
    
    
    private func createAlbum(albumName: String) async -> PHAssetCollection? {
        await withCheckedContinuation { continuation in
            var albumPlaceholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if success {
                    guard let albumPlaceholder = albumPlaceholder else { return }
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                    guard let album = collectionFetchResult.firstObject else { return }
                    continuation.resume(returning: album)
                } else {
                    log.error(error?.localizedDescription ?? "Error creating new album")
                    continuation.resume(returning: nil)
                }
            })
        }
    }
    

    
    private func albumExists(albumName: String) -> Bool {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject != nil
    }
    
    
    private func saveVideoToAlbum(videoURL: URL, to album: PHAssetCollection) async {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
                albumChangeRequest?.addAssets(enumeration)
            }, completionHandler: { success, error in
                if success {
                    log.success("Successfully saved video to album")
                    continuation.resume()
                } else {
                    log.error(error?.localizedDescription ?? "Error saving video to album")
                    continuation.resume()
                }
            })
        }
    }
}
