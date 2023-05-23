    //
    //  CardDetector.swift
    //  MySavings-IOS
    //
    //  Created by Ruben Mimoun on 15/05/2023.
    //

import Foundation
import Vision
import CoreImage
import UIKit

protocol CardDetectorProtocol : AnyObject {
    
    var snapped: Bool { get set }
    
    func onDetecRectangle(in image: CVPixelBuffer)
}

protocol CardDetectionResultProtocol : AnyObject {
    func onError(error : Error?)
    func onDetect(rect : VNRectangleObservation,and image: UIImage)
    func doPerspectiveCorrection(_ observation: VNRectangleObservation, from buffer: CVImageBuffer)}

class CardDetector {
    
    weak var delegate: (CapturedController & CardDetectionResultProtocol)?
    
    private var frameCount = 0
    private var normalizedFrame: CGRect = .zero
    private var _snapped: Bool = false
    let paymentCardAspectRatio: Float = 86.60 / 53.98
    
    init(delegate:  (CapturedController & CardDetectionResultProtocol)? = nil) {
        self.delegate = delegate
        normalizedFrame = getPointOfInterest()
        print(normalizedFrame)
    }
    
    private func getPointOfInterest() -> CGRect {
        let width: CGFloat = 340
        let height: CGFloat = 211
        guard let viewFrame = delegate?.view.bounds else { return .zero  }
        let frame: CGRect = .init(origin: .init(x: (viewFrame.width - width) / 2, y: ( viewFrame.height - height) / 2),
                                        size: .init(width: width, height: height))
        let screenFrame =  UIScreen.main.bounds
        let currentMiny =  (screenFrame.height - frame.height) / 2
        let currentMinX = (screenFrame.width - frame.width) / 2
        let normalizedFrame = CGRect(
            origin: .init(x: currentMinX / screenFrame.maxX , y: currentMiny / screenFrame.maxY ),
            size: .init(width: frame.width / screenFrame.width, height: frame.height / screenFrame.height)
        )
        return normalizedFrame
    }
    
    var textRecognitionRequest: VNRecognizeTextRequest? = nil
}

extension CardDetector: CardDetectorProtocol {
    
    var snapped: Bool {
        get { _snapped }
        set { _snapped = newValue }
    }
    
    func onDetecRectangle(in image: CVPixelBuffer) {
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image)
        
        let rectangleRequest = VNDetectRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.onError(error: error)
            }
            if let results =  request.results as? [VNRectangleObservation],
               let rect = results.first{
                
                DispatchQueue.main.async {
                    self.delegate?.onDetect(rect: rect, and: image.toUIImage())
                    
                    if self.snapped {
                        self.snapped = false
                        self.delegate?.doPerspectiveCorrection(rect, from: image)
                    }
                }
            }
        }
        
        rectangleRequest.minimumAspectRatio = paymentCardAspectRatio
        rectangleRequest.maximumAspectRatio = paymentCardAspectRatio 
        //rectangleRequest.minimumSize = Float(0.7)
        rectangleRequest.regionOfInterest = normalizedFrame

        try? imageRequestHandler.perform([rectangleRequest])
    }
    
}

fileprivate extension CVPixelBuffer {
    func toUIImage() -> UIImage {
        let ciImage = CIImage(cvPixelBuffer: self)
        let uiImage = UIImage(ciImage: ciImage)
        return uiImage
    }
}
