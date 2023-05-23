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
import AVFoundation

struct CardScannerView: UIViewControllerRepresentable {
    
    @EnvironmentObject var viewModel: CaptureState
    
    func makeUIViewController(context: Context) -> CapturedController {
        let vc: CapturedController = .load("CaptureScene")
        vc.viewModel = viewModel
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CapturedController, context: Context) {
        
    }
    
    typealias UIViewControllerType = CapturedController
    
}

class CapturedController: UIViewController{
    
    lazy var captureManager : CaptureManager = .init()
    lazy var cardDetector   : CardDetectorProtocol = CardDetector(delegate: self)
    var viewModel: CaptureState!
    
    @IBOutlet weak var snapButton: UIButton!
    
    
    lazy var maskLayer : CAShapeLayer  = {
        let layer  = CAShapeLayer()
        layer.cornerRadius = 10
        layer.opacity = 0.75
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 5.0
        return layer
    }()
    
    var previewLayer : CameraPreview {
        captureManager.previewLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setupCaptureManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardDetector.snapped = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.previewLayer.videoPreviewLayer.sublayers?.remove(at: 1)
    }
    
    @IBAction func onSnap(_ sender: Any) {
        cardDetector.snapped =  true
    }
    
    private func initUI() {
        self.view.layer.cornerRadius = 12
        snapButton.backgroundColor = .white
        snapButton.layer.cornerRadius = 30
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let circle = CALayer()
        
        circle.frame = .init(
            origin: .init(x:snapButton.bounds.origin.x - 10,
                          y: snapButton.bounds.origin.y - 10),
            size: .init(width: snapButton.bounds.width + 20,
                        height: snapButton.bounds.height + 20))
        circle.cornerRadius = 40
        circle.borderWidth = 2
        circle.borderColor = UIColor.white.cgColor
        circle.backgroundColor = UIColor.clear.cgColor
        snapButton.layer.addSublayer(circle)
    }
    
    private func setupCaptureManager() {
        Task {
            #if targetEnvironment(simulator)
            let imageTest = UIImage(named: "cc-test", in: Bundle.module)!.buffer()
            cardDetector.onDetecRectangle(in: imageTest)
            #else
            await captureManager.initConfiguration()
            captureManager.delegate = cardDetector
            captureManager.addTo(view: self.view)
            #endif
        }
    }
    
    func getConvertedRect(boundingBox: CGRect, inImage imageSize: CGSize, containedIn containerSize: CGSize) -> CGRect {
        
        let rectOfImage: CGRect
        
        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height
        
        if imageAspect > containerAspect { /// image extends left and right
            let newImageWidth = containerSize.height * imageAspect /// the width of the overflowing image
            let newX = -(newImageWidth - containerSize.width) / 2
            rectOfImage = CGRect(x: newX, y: 0, width: newImageWidth, height: containerSize.height)
            
        } else { /// image extends top and bottom
            let newImageHeight = containerSize.width * (1 / imageAspect) /// the width of the overflowing image
            let newY = -(newImageHeight - containerSize.height) / 2
            rectOfImage = CGRect(x: 0, y: newY, width: containerSize.width, height: newImageHeight)
        }
        
        let newOriginBoundingBox = CGRect(
            x: boundingBox.origin.x,
            y: 1 - boundingBox.origin.y - boundingBox.height,
            width: boundingBox.width,
            height: boundingBox.height
        )
        
        var convertedRect = VNImageRectForNormalizedRect(newOriginBoundingBox, Int(rectOfImage.width), Int(rectOfImage.height))
        
            /// add the margins
        convertedRect.origin.x += rectOfImage.origin.x
        convertedRect.origin.y += rectOfImage.origin.y
        
        return convertedRect
    }
    
    private func createLayer(in rect: CGRect) {
        self.maskLayer.frame = rect
        self.previewLayer.videoPreviewLayer.insertSublayer(maskLayer, at: 1)
    }
    
}

fileprivate extension CALayer {
    
    func scaleIn() {
        let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(timing)
        let scaleLayer = CABasicAnimation(keyPath: "transform.scale")
        scaleLayer.fromValue = 0.0
        scaleLayer.toValue = 1.0
        scaleLayer.duration = 1.0
        self.add(scaleLayer, forKey: "opacityAnimation")
        CATransaction.commit()
    }
    
    func scaleOut() {
        let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.1)
        CATransaction.setAnimationTimingFunction(timing)
        let scaleLayer = CABasicAnimation(keyPath: "transform.scale")
        scaleLayer.fromValue = 1.0
        scaleLayer.toValue = 0.0
        scaleLayer.duration = 1.0
        self.add(scaleLayer, forKey: "opacityAnimation")
        CATransaction.commit()
    }
    
}


extension CapturedController: CardDetectionResultProtocol {
    
    
    func onError(error: Error?) {
        if let error = error {
            Log.e(error: error)
        }
    }
    
    func onDetect(rect: VNRectangleObservation, and image: UIImage) {
        let bbox = getConvertedRect(boundingBox: rect.boundingBox,
                                    inImage: image.size,
                                    containedIn: self.view.frame.size)
        self.createLayer(in: bbox)
        
    }
    
    func doPerspectiveCorrection(_ observation: VNRectangleObservation, from buffer: CVImageBuffer) {
        var ciImage = CIImage(cvImageBuffer: buffer)
        
        let topLeft = observation.topLeft.scaled(to: ciImage.extent.size)
        let topRight = observation.topRight.scaled(to: ciImage.extent.size)
        let bottomLeft = observation.bottomLeft.scaled(to: ciImage.extent.size)
        let bottomRight = observation.bottomRight.scaled(to: ciImage.extent.size)
        
            // pass those to the filter to extract/rectify the image
        ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: topLeft),
            "inputTopRight": CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight": CIVector(cgPoint: bottomRight),
        ])
        
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
            //detectText(from: cgImage!)
        let output = UIImage(cgImage: cgImage!)
        viewModel.onCaptured(captured: output)
    }
}

extension CGPoint {
    func scaled(to size: CGSize) -> CGPoint {
        return CGPoint(x: self.x * size.width, y: self.y * size.height)
    }
}

extension UIViewController  {
    static func load<T: UIViewController> (_ scene: String) -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: scene, bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return vc
    }
}

extension UIImage {
    func buffer() -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: self.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
}
