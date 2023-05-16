//
//  CardDetector.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 15/05/2023.
//

import Foundation
import Vision

protocol CardDetectorProtocol : AnyObject {
    func onDetecRectable(in image: CVPixelBuffer)
}

protocol CardDetectionResultProtocol : AnyObject {
    func onError(error : Error?)
    func onDetect(rect : VNRectangleObservation)
    func onTextDetected(text : String)
}

class CardDetector {
    
    weak var delegate: CardDetectionResultProtocol?
    
    private var frameCount = 0

    init(delegate: CardDetectionResultProtocol? = nil) {
        self.delegate = delegate
    }
}

extension CardDetector: CardDetectorProtocol {
    
    func onDetecRectable(in image: CVPixelBuffer) {
        
        frameCount += 1
        guard frameCount > 15 else { return }
        self.frameCount = 0
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image)

        
        let textRecognitionRequest = VNRecognizeTextRequest {[weak self] (request, error) in
               guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
               for observation in observations {
                   guard let topCandidate = observation.topCandidates(1).first else { return }
                   self?.delegate?.onTextDetected(text: topCandidate.string)
               }            
           }
        
        let request = VNDetectRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }

            if let error = error {
                self.delegate?.onError(error: error)
            }

            if let results =  request.results as? [VNRectangleObservation],
               let rect = results.first {
                DispatchQueue.main.async {
                    self.delegate?.onDetect(rect: rect)
                }
                try? imageRequestHandler.perform([textRecognitionRequest])
            }
        }

        request.minimumAspectRatio = VNAspectRatio(1.3)
        request.maximumAspectRatio = VNAspectRatio(1.75)
        request.maximumObservations =  1
        
        try? imageRequestHandler.perform([request])
    }
    
}
