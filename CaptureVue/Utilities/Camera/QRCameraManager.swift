//
//  QRCameraManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 31/10/24.
//

import Foundation
import AVFoundation
import Combine
import UIKit

extension QRCameraManager: AVCapturePhotoCaptureDelegate {
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?){
        if let imageData = photo.fileDataRepresentation() {
            onImageCapture?(UIImage(data: imageData)!) // Store the last captured image
        }
    }
    
}


extension QRCameraManager: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if codeFetched {
            return
        }
        
            if let metaObject = metadataObjects.first {
                guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let scannedCode = readableObject.stringValue else { return }
                self.onQRDetected?(scannedCode, readableObject.bounds)
                self.capturePhoto()
                    self.codeFetched = true
                print(scannedCode)
            }
        
        
        
    }
}


class QRCameraManager: NSObject, ObservableObject{
    
    static let shared: QRCameraManager = QRCameraManager()
    
    let session =  AVCaptureSession()
    private let sessionQueue: DispatchQueue = DispatchQueue(label: "com.capturevue.session.qrcode")
    private var videoDeviceInput: AVCaptureDeviceInput? = nil
    
    private var codeFetched: Bool = false
    var onQRDetected: ((String, CGRect) -> Void)? = nil
    var onImageCapture: ((UIImage) -> Void)? = nil
    
    @Published var qrOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    @Published var photoOutput = AVCapturePhotoOutput()
    @Published var permissionStatus: PermissionStatus = .unknown
    @Published var availableCameraPositions: [AVCaptureDevice.Position]? = nil
    
    
    
    func getQrFrame(onQRDetected: @escaping (String, CGRect) -> Void){
        self.onQRDetected = onQRDetected
        
    }
    
    func getImage(onImageCapture: @escaping ((UIImage) -> Void) ){
        self.onImageCapture = onImageCapture
    }
    
    func bind() {
        checkPermissions()
        
        sessionQueue.async {
            self.addOutput()
        }
    }
    
    func unbind() {
        sessionQueue.async {
            if self.session.isRunning {
                if let input = self.videoDeviceInput {
                    self.session.removeInput(input)
                }
                
                
                self.session.removeOutput(self.photoOutput)
                self.session.removeOutput(self.qrOutput)
                self.session.stopRunning()
            }
            
            self.availableCameraPositions = nil
            
            DispatchQueue.main.async {
                self.codeFetched = false
            }
        }
    }
    
    func capturePhoto(){
        
        sessionQueue.async{
            var photoSettings = AVCapturePhotoSettings()
            
            if self.photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            }
            
            photoSettings.photoQualityPrioritization = .speed
            
            
            // Preview Photo Settings
            //        if photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 {
            //            photoSettings.previewPhotoFormat = [
            //                kCVPixelBufferPixelFormatTypeKey : photoSettings.availablePreviewPhotoPixelFormatTypes.first!,
            //                kCVPixelBufferWidthKey : 1920,
            //                kCVPixelBufferHeightKey : 1080
            //            ] as [String: Any]
            //        }
            
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
            
        }
    }
    

    
    
    func onCameraSelect(position: AVCaptureDevice.Position) {
        sessionQueue.async {
            let devices = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
                mediaType: .video,
                position: position
            ).devices
            
            var newVideoDevice: AVCaptureDevice? = nil
            if let device = devices.first(where: { $0.position == position && $0.deviceType == .builtInWideAngleCamera }) {
                newVideoDevice = device
            } else if let device = devices.first(where: { $0.position == position }) {
                newVideoDevice = device
            }
            
            if let videoDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    
                    self.session.beginConfiguration()
                    
                    if let currentDeviceInput = self.videoDeviceInput {
                        self.session.removeInput(currentDeviceInput)
                    }
                    
                    if self.session.canAddInput(videoDeviceInput) {
                        self.session.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else if let currentDeviceInput = self.videoDeviceInput {
                        self.session.addInput(currentDeviceInput)
                    }
                    
                    self.session.commitConfiguration()
                } catch {
                    print("Error on adding device \(error.localizedDescription)")
                }
            }
        }
    }
    
    func addOutput(){
        guard permissionStatus == .authorized else {
            return
        }
        
        session.beginConfiguration()
        
        if session.canAddOutput(qrOutput) {
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(self, queue: .main)
        }else{
            print("Cannot Add QR Output")
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }else{
            print("Cannot Add Photo Output")
        }
        
        session.commitConfiguration()
        
        session.startRunning()
    }
    
    private func checkPermissions() {
        PermissionAlertStatus.shared.setVisible(isVisible: true)
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if authorized {
                    self.permissionStatus = .authorized
                } else {
                    self.permissionStatus = .unauthorized
                }
                PermissionAlertStatus.shared.setVisible(isVisible: false)
                self.sessionQueue.resume()
            }
        case .restricted:
            permissionStatus = .unauthorized
            PermissionAlertStatus.shared.setVisible(isVisible: false)
        case .denied:
            permissionStatus = .unauthorized
            PermissionAlertStatus.shared.setVisible(isVisible: false)
        case .authorized:
            permissionStatus = .authorized
            PermissionAlertStatus.shared.setVisible(isVisible: false)
            break
        @unknown default:
            permissionStatus = .unknown
            PermissionAlertStatus.shared.setVisible(isVisible: false)
        }
    }
    
    
    enum PermissionStatus {
        case unknown
        case authorized
        case unauthorized
    }
    
}







class QRCameraFeed: ObservableObject {
    
    @Published var permissionStatus: QRCameraManager.PermissionStatus = .unknown
    @Published var availableCameraPositions: [AVCaptureDevice.Position]? = nil
    
    let cameraManager: QRCameraManager = QRCameraManager.shared
    
    var session: AVCaptureSession {
        return cameraManager.session
    }
    
    init(){
        onCameraSelect(position: .back)
        cameraManager.$permissionStatus
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$permissionStatus)
        
        cameraManager.$availableCameraPositions
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$availableCameraPositions)
    }
    
    func start(){
        cameraManager.bind()
    }
    
    func stop(){
        cameraManager.unbind()
    }
    
    func onCameraSelect(position: AVCaptureDevice.Position) {
        cameraManager.onCameraSelect(position: position)
    }
    
}
