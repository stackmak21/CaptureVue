//
//  CapturePhotoProccessor.swift
//  CaptureVue
//
//  Created by Paris Makris on 15/3/25.
//

import Foundation
import SwiftUI
import UIKit
import Photos
import AVFoundation

class CapturePhotoProccessor : NSObject {
    
    private let photoOutput: AVCapturePhotoOutput
    private let videoDeviceInput: AVCaptureDeviceInput?
    
    private let onStartCapturing: () -> Void
    private let completionHandler: (UIImage?, UIImage?) -> Void
    
    private var previewImage: UIImage? = nil
    private var originalImage: UIImage? = nil

    init(
        photoOutput: AVCapturePhotoOutput,
        videoDeviceInput: AVCaptureDeviceInput?,
        onStartCapturing: @escaping () -> Void,
        onCapture: @escaping (UIImage?, UIImage?) -> Void
    ) {
        self.photoOutput = photoOutput
        self.videoDeviceInput = videoDeviceInput
        self.onStartCapturing = onStartCapturing
        self.completionHandler = onCapture
    }
    
    func generatePhotoSettings() -> AVCapturePhotoSettings{
        
        var photoSettings = AVCapturePhotoSettings()
        if self.photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        }
        
        let isFlashAvailable = self.videoDeviceInput?.device.isFlashAvailable ?? false
        
        // Preview Photo Settings
        if photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 {
            photoSettings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey : photoSettings.availablePreviewPhotoPixelFormatTypes.first!,
                kCVPixelBufferWidthKey : 512,
                kCVPixelBufferHeightKey : 512
            ] as [String: Any]
        }
        
        
//        // Thumbnail Photo Settings
//        photoSettings.embeddedThumbnailPhotoFormat = [
//            AVVideoCodecKey: AVVideoCodecType.jpeg,
//            AVVideoWidthKey: 1024,
//            AVVideoHeightKey: 1024,
//        ]

        photoSettings.flashMode = isFlashAvailable ? .on : .off
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.photoQualityPrioritization = .balanced
        return photoSettings
    }
}


extension CapturePhotoProccessor: AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        if let previewCIImage = photo.previewCGImageRepresentation() {
            if let previewUIImage = UIImage(cgImage: previewCIImage).rotate(angle: Angle(degrees: 90)){
                previewImage = previewUIImage
            }
        }
        
        if let originalImageData = photo.fileDataRepresentation(){
            originalImage = UIImage(data: originalImageData)
        }
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: (any Error)?) {
        completionHandler(previewImage, originalImage)
    }
    
    
}
