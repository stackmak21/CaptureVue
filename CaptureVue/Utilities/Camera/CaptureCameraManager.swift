//
//  CaptureCameraManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 10/3/25.
//


import AVFoundation
import UIKit



class CaptureCameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    static let shared: CaptureCameraManager = CaptureCameraManager()
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.bitvalve.ios.session.capture")
    private var videoDeviceInput: AVCaptureDeviceInput? = nil
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private let videoOutputQueue = DispatchQueue(
        label: "com.bitvalve.ios.video.queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    @Published var permissionStatus: PermissionStatus = .unknown
    @Published var availableCameraPositions: [AVCaptureDevice.Position]? = nil
    @Published var flashlightStatus: FlashlightStatus = .unavailable
    
    func bind() {
        checkPermissions()
        
        sessionQueue.async {
            self.checkSensors()
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
                self.session.stopRunning()
            }
            
            self.availableCameraPositions = nil
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
                    
                    if let connection = self.photoOutput.connection(with: .video) {
                        if connection.isVideoStabilizationSupported {
                            connection.preferredVideoStabilizationMode = .auto
                        }
                    }
                    
                    if videoDevice.hasTorch {
                        if videoDevice.torchMode == .on {
                            self.flashlightStatus = .enabled
                        } else if videoDevice.torchMode == .off {
                            self.flashlightStatus = .disabled
                        }
                    } else {
                        self.flashlightStatus = .unavailable
                    }
                    
                    self.session.commitConfiguration()
                } catch {
                    print("Error on adding device \(error)")
                }
            }
        }
    }
    
    func onFlashlightChange(isEnabled: Bool) {
        guard flashlightStatus != .unavailable else {
            return
        }
        
        if (flashlightStatus == .enabled && isEnabled) || (flashlightStatus == .disabled && !isEnabled) {
            return
        }
        
        if let device = videoDeviceInput?.device {
            do {
                try device.lockForConfiguration()
                device.torchMode = isEnabled ? .on : .off
                device.unlockForConfiguration()
                
                flashlightStatus = isEnabled ? .enabled : .disabled
            } catch {
                print("Could not change torch mode \(error)")
            }
        }
    }
    
//    func onCapturePhoto(
//        fileName: String,
//        previewArea: CGRect,
//        onStartCapturing: @escaping () -> Void,
//        onPhotoReceived: @escaping (URL) -> Void,
//        onError: @escaping (Error) -> Void
//    ) {
//        sessionQueue.async {
//            if let photoOutputConnection = self.photoOutput.connection(with: .video) {
//                photoOutputConnection.videoOrientation = .portrait
//                photoOutputConnection.isVideoMirrored = isMirrored
//            }
//            
//            var photoSettings = AVCapturePhotoSettings()
//            if  self.photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
//                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//            }
//            photoSettings.isHighResolutionPhotoEnabled = true
//            photoSettings.photoQualityPrioritization = .quality
//            
//            let captureProcessor = VerificationPhotographer(
//                with: photoSettings,
//                name: fileName,
//                previewArea: previewArea,
//                cropArea: cropArea,
//                isLandscape: isLandscape,
//                onStartCapturing: onStartCapturing,
//                onCapture: { processor, url, error in
//                    self.sessionQueue.async {
//                        self.inProgressPhotoCaptureDelegates[processor.requestedPhotoSettings.uniqueID] = nil
//                    }
//                    
//                    if let url = url {
//                        onPhotoReceived(url)
//                    } else if let error = error {
//                        onError(error)
//                    }
//                }
//            )
//            
//            self.inProgressPhotoCaptureDelegates[captureProcessor.requestedPhotoSettings.uniqueID] = captureProcessor
//            self.photoOutput.capturePhoto(with: photoSettings, delegate: captureProcessor)
//        }
//    }
    
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
    
    private func checkSensors() {
        guard availableCameraPositions == nil && permissionStatus == .authorized else {
            return
        }
        
        var cameraPositions: [AVCaptureDevice.Position] = []
        
        let frontDevices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front
        ).devices
        
        if !frontDevices.filter({ $0.position == .front }).isEmpty {
            cameraPositions.append(.front)
        }
        
        let backDevices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .back
        ).devices
        
        if !backDevices.filter({ $0.position == .back }).isEmpty {
            cameraPositions.append(.back)
        }
        
        availableCameraPositions = cameraPositions
    }
    
    private func addOutput() {
        guard permissionStatus == .authorized else {
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.maxPhotoQualityPrioritization = .quality
        } else {
            print("Cannot add photo output")
        }
        
        session.commitConfiguration()
        
        self.session.startRunning()
    }
    
    enum PermissionStatus {
        case unknown
        case authorized
        case unauthorized
    }
    
    enum FlashlightStatus {
        case unavailable
        case disabled
        case enabled
    }
}

class CaptureCameraFeed: ObservableObject {
    
    @Published var permissionStatus: CaptureCameraManager.PermissionStatus = .unknown
    @Published var availableCameraPositions: [AVCaptureDevice.Position]? = nil
    @Published var flashlightStatus: CaptureCameraManager.FlashlightStatus = .unavailable
    
    private let cameraManager: CaptureCameraManager = CaptureCameraManager.shared
    
    var session: AVCaptureSession {
        return cameraManager.session
    }
    
    init() {
        cameraManager.$permissionStatus
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$permissionStatus)
        
        cameraManager.$availableCameraPositions
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$availableCameraPositions)
        
        cameraManager.$flashlightStatus
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$flashlightStatus)
    }
    
    func start() {
        cameraManager.bind()
    }
    
    func onCameraSelect(position: AVCaptureDevice.Position) {
        cameraManager.onCameraSelect(position: position)
    }
    
    func setFlashLightEnabled(enabled: Bool) {
        cameraManager.onFlashlightChange(isEnabled: enabled)
    }
    
//    func capturePhoto(
//        withName fileName: String,
//        preview previewArea: CGRect,
//        crop cropArea: CGRect,
//        isMirrored: Bool,
//        isLandscape: Bool,
//        onStartCapturing: @escaping () -> Void,
//        onPhotoReceived: @escaping (URL) -> Void,
//        onError: @escaping (VerificationPhotographer.CaptureError) -> Void
//    ) {
//        cameraManager.onCapturePhoto(
//            fileName: fileName,
//            previewArea: previewArea,
//            cropArea: cropArea,
//            isMirrored: isMirrored,
//            isLandscape: isLandscape,
//            onStartCapturing: onStartCapturing,
//            onPhotoReceived: onPhotoReceived,
//            onError: onError
//        )
//    }
    
    func stop() {
        cameraManager.unbind()
    }
    
}
