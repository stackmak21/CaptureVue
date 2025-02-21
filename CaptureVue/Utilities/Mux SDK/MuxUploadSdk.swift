//
//  MuxUploadSdk.swift
//  CaptureVue
//
//  Created by Paris Makris on 27/1/25.
//

import Foundation
import MuxUploadSDK

class MuxUploadSdk {

    
    func uploadVideoToMux(uploadUrl: String, videoUrl: String, progress: @escaping (Progress) -> Void) {
        guard let muxUrl = URL(string: "\(uploadUrl)") else {
            print("Invalid upload URL")
            return
        }
        guard let videoLocalUrl = URL(string: "\(videoUrl)") else {
            print("Invalid video URL")
            return
        }

        let directUpload = DirectUpload(uploadURL: muxUrl, inputFileURL: videoLocalUrl)
        
        directUpload.progressHandler = {
            if let progressValue = $0.progress{
                progress(progressValue)
            }
        }
        
        directUpload.start()
    }
    
}
