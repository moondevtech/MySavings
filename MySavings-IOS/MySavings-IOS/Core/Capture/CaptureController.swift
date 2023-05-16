    //
    //  CaptureController.swift
    //  MySavings-IOS
    //
    //  Created by Ruben Mimoun on 15/05/2023.
    //

import Foundation
import UIKit
import SwiftUI
import Vision

struct CardScannerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CaptureController {
        return CaptureController(nibName: nil, bundle: nil)
    }
    
    func updateUIViewController(_ uiViewController: CaptureController, context: Context) {
        
    }
    
    typealias UIViewControllerType = CaptureController
    
}

class CaptureController: UIViewController {
    
    lazy var captureManager : CaptureManager = .init()
    lazy var cardDetector   : CardDetector = .init(delegate: self)
    lazy var capturedTextHandler: CapturedTextHandler = .init(delegate: self)
    
    var previewLayer : CameraPreview {
        captureManager.previewLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureManager()
    }
    
    private func setupCaptureManager() {
        Task {
            await captureManager.initConfiguration()
            captureManager.delegate = cardDetector
            captureManager.addTo(view: self.view)
        }
    }

    private func drawBoundingBox(rect : VNRectangleObservation) {
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.previewLayer.frame.height)
        let scale = CGAffineTransform.identity.scaledBy(x: self.previewLayer.frame.width, y: self.previewLayer.frame.height)
        let bounds = rect.boundingBox.applying(scale).applying(transform)
        createLayer(in: bounds)
    }
    
    private func createLayer(in rect: CGRect) {
        previewLayer.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.cornerRadius = 10
        maskLayer.opacity = 0.75
        maskLayer.borderColor = UIColor.red.cgColor
        maskLayer.borderWidth = 5.0
        
        previewLayer.videoPreviewLayer.insertSublayer(maskLayer, at: 1)
    }
}


extension CaptureController: CardDetectionResultProtocol {
    
    func onError(error: Error?) {
        
    }
    
    func onDetect(rect: VNRectangleObservation) {
        self.drawBoundingBox(rect: rect)
    }
    
    func onTextDetected(text: String) {
        capturedTextHandler.onCapturedText(text: text)
    }

}

extension CaptureController: OnCapturedCardResultProtocol {
    
    func onCaptureCard(card: CapturedTextHandler.CapturedCard) {
        print("onCaptureCard", card)
    }
}

extension CGPoint {
    func scaled(to size: CGSize) -> CGPoint {
        return CGPoint(x: self.x * size.width, y: self.y * size.height)
    }
}
