    //
    //  TextExtractorVC.swift
    //  VisionCreditScan
    //
    //  Created by Anupam Chugh on 27/01/20.
    //  Copyright © 2020 iowncode. All rights reserved.
    //

import UIKit
import SwiftUI
import Vision

struct CardTextExtractorView: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: CaptureState
    var scannedImage: UIImage
    
    func makeUIViewController(context: Context) -> TextExtractor {
        return TextExtractor(viewModel: viewModel, image: scannedImage)
    }
    
    func updateUIViewController(_ uiViewController: TextExtractor, context: Context) {}
    
    typealias UIViewControllerType = TextExtractor
    
}


class TextExtractor: UIViewController {
    
    let queue = OperationQueue()
    
    let overlay = UIView()
    var lastPoint = CGPoint.zero
    
    var textRecognitionRequest: VNRecognizeTextRequest?
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    var viewModel: CaptureState
    var scannedImage : UIImage?
    
    private var maskLayer = [CAShapeLayer]()
    
    lazy var imageView : UIImageView = {
        let b = UIImageView()
        b.contentMode = .scaleAspectFit
        view.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        b.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        b.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        b.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return b
    }()

    @objc func doExtraction(sender: UIButton!){
        processImage(snapshot(in: imageView, rect: overlay.frame))
    }
    
    func snapshot(in imageView: UIImageView, rect: CGRect) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect).image { _ in
            clearOverlay()
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
    }
    
    init(viewModel: CaptureState, image: UIImage) {
        self.scannedImage = image
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        Log.i(content: "deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVision()
        self.view.backgroundColor = .black
        imageView.image = scannedImage
        overlay.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        overlay.isHidden = true
        imageView.addSubview(overlay)
        imageView.bringSubviewToFront(overlay)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textRecognitionWorkQueue.suspend()
        textRecognitionRequest = nil
    }
    
    private func setupVision() {
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                detectedText = topCandidate.string
            }
            
            DispatchQueue.main.async{[weak self] in
                self?.viewModel.onExtract(detectedText)
            }
        }
        textRecognitionRequest?.recognitionLevel = .accurate
    }
    
    private func processImage(_ image: UIImage) {
        recognizeTextInImage(image)
    }
    
    private func recognizeTextInImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest!])
            } catch {
                print(error)
            }
        }
    }
    
    func clearOverlay(){
        overlay.isHidden = false
        overlay.frame = CGRect.zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clearOverlay()
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawSelectionArea(fromPoint: lastPoint, toPoint: currentPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        processImage(snapshot(in: imageView, rect: overlay.frame))
    }
    
    func drawSelectionArea(fromPoint: CGPoint, toPoint: CGPoint) {
        let rect = CGRect(x: min(fromPoint.x, toPoint.x),
                          y: min(fromPoint.y, toPoint.y),
                          width: abs(fromPoint.x - toPoint.x),
                          height: abs(fromPoint.y - toPoint.y))
        
        overlay.layer.cornerRadius = rect.height / 2
        overlay.frame = rect
    }
}
