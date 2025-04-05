//
//  CaptureVideoProccessor.swift
//  CaptureVue
//
//  Created by Paris Makris on 4/4/25.
//

import Foundation
import SwiftUI
import UIKit
import Photos
import AVFoundation

class CaptureVideoProccessor: NSObject {
    
    let onVideoCaptureFinished: (URL) -> Void
    
    init(onVideoCaptureFinished: @escaping (URL) -> Void) {
        self.onVideoCaptureFinished = onVideoCaptureFinished
    }

}


extension CaptureVideoProccessor: AVCaptureFileOutputRecordingDelegate{
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        onVideoCaptureFinished(outputFileURL)
    }

}
