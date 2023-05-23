//
//  CaptureManager.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 15/05/2023.
//

import Foundation
import UIKit
import AVFoundation
import CoreML

class CaptureManager: NSObject {
    
    private var screenRect     : CGRect = UIScreen.main.bounds
    private var captureDevice  : AVCaptureDevice!
    private var captureSession : AVCaptureSession
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    var previewLayer   : CameraPreview!
    weak var delegate: CardDetectorProtocol?

    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
        [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
        mediaType: .video, position: .unspecified)
    
    override init() {
        captureSession =  AVCaptureSession()
        super.init()
        captureDevice  = bestDevice(in: .back)
    }
    
    private func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        let devices = self.discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}

        return devices.first(where: { device in device.position == position })!
    }
    
    private func getCameraPermission() async -> Bool {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            return true
        } else {
            let granted =  await  withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video){ granted  in
                    continuation.resume(with: .success(granted))
                }
            }
            return granted
        }
    }
    
    private func setCameraOutput() {
        let queue = DispatchQueue(label: "com.cameraoutput.queue")
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        self.captureSession.addOutput(videoDataOutput)
        guard let connection = self.videoDataOutput.connection(with: .video) else { return  }
        connection.videoOrientation = .portrait
    }
    
    func initConfiguration() async {
        let queue =  DispatchQueue(label: "com.capture.setup", qos: .userInitiated)
        guard await getCameraPermission() else {
            return
        }
        queue.async { [weak self] in
            guard let self = self else { return }
            self.captureSession.beginConfiguration()
            
            guard let videoDeviceInput = try? AVCaptureDeviceInput(device: self.captureDevice),
                  self.captureSession.canAddInput(videoDeviceInput) else {
                return
            }
            self.captureSession.addInput(videoDeviceInput)
            self.captureSession.commitConfiguration()
            self.setCameraOutput()
            self.captureSession.startRunning()
        }
    }
    
    func addTo(view : UIView) {
        previewLayer = CameraPreview(frame: view.bounds)
        previewLayer.videoPreviewLayer.videoGravity = .resizeAspectFill
        previewLayer.videoPreviewLayer.connection?.videoOrientation =  .portrait
        previewLayer.videoPreviewLayer.session  = captureSession
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            view.layer.insertSublayer(self.previewLayer.videoPreviewLayer, at: 0)
        }
    }
    
    func start() {
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self = self else { return }
            self.captureSession.startRunning()
        }
    }
    
    func stop() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.captureSession.stopRunning()
        }
    }
}

extension CaptureManager : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
             debugPrint("unable to get image from sample buffer")
             return
         }
        delegate?.onDetecRectangle(in: pixelBuffer)
    }
}


class CameraPreview: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override func layoutSubviews() {
        self.videoPreviewLayer.frame = self.bounds
    }
}
