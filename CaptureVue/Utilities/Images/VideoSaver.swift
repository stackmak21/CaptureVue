//
//  VideoSaver.swift
//  CaptureVue
//
//  Created by Paris Makris on 11/4/25.
//


import UIKit
import Photos

class VideoSaver: NSObject {
    
    
    
    deinit{
        print("Video saver Deallocated")
    }
//    
////    private func saveVideoToAlbum(videoURL: URL) async {
////        await withCheckedContinuation { continuation in
////            save
////        }
////    }
//    
//    func saveVideoToAlbum(videoURL: URL) {
//        print(#function, Thread.current)
//            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoURL.path) {
//                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, self, #selector(videoSaveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
//                
//            } else {
//                print("🚫 Video not compatible with photo album.")
//                
//            }
//        
//    }
//
//    @objc private func videoSaveCompleted(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            print("❌ Error saving video: \(error.localizedDescription)")
//        } else {
//            print("✅ Video saved successfully!")
//        }
//    }
    
    func saveVideoToAlbum(videoURL: URL, albumName: String) async {
        
            
            
            if albumExists(albumName: albumName) {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                if let album = collection.firstObject {
                    await saveVideo(videoURL: videoURL, to: album)
                }
            } else {
                if let album = await createAlbum(videoURL: videoURL, albumName: albumName){
                    await saveVideo(videoURL: videoURL, to: album)
                }
            }
        
    }
    
    private func createAlbum(videoURL: URL, albumName: String) async -> PHAssetCollection? {
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
                    print("Error creating album: \(error?.localizedDescription ?? "")")
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

    private func saveVideo(videoURL: URL, to album: PHAssetCollection) async {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
                albumChangeRequest?.addAssets(enumeration)
            }, completionHandler: { success, error in
                if success {
                    print("Successfully saved video to album")
                    continuation.resume()
                } else {
                    print("Error saving video to album: \(error?.localizedDescription ?? "")")
                    continuation.resume()
                }
            })
        }
    }
}
