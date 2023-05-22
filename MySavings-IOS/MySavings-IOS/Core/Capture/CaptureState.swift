//
//  CaptureState.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/05/2023.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class CaptureState: ObservableObject {
    
    struct Extracted : Equatable {
        var holder: String = ""
        var number: String = ""
        var dateScanned : String = ""
        
        var isFullfilled: Bool {
            !holder.isEmpty &&
            !number.isEmpty &&
            !dateScanned.isEmpty
        }
        
        var date: Date {
            let dateFormatter =  DateFormatter()
            dateFormatter.dateFormat = "MM/YY"
            return dateFormatter.date(from: dateScanned)!
        }
        
    }
        
    enum CaptureValue {
        case cardNumber
        case name
        case date
    }
    
    @Published var captureState: CaptureValue = .cardNumber
    @Published var extracted: Extracted = .init()
    @Published var path: NavigationPath = .init()
    private var restartCapture: PassthroughSubject<(),Never> = .init()
    private var onCapture: PassthroughSubject<UIImage,Never> = .init()
    
    func onCaptured(captured: UIImage) {
       // self.onCapture.send(captured)
        self.path.append(captured)
    }
    
    func onRestart() {
        self.restartCapture.send(())
    }
    
    func onExtract(_ text: String) {
        switch captureState {
            case .cardNumber:
                extractedNumber = text
            case .name:
                extractedName =  text
            case .date:
                extractedDate = text
        }
    }
}

extension CaptureState {
    
    var extractedName: String {
        get { extracted.holder }
        set { extracted.holder = newValue }
    }
    
    var extractedNumber: String {
        get { extracted.number }
        set { extracted.number = newValue }
    }
    
    var extractedDate: String {
        get { extracted.dateScanned }
        set { extracted.dateScanned = newValue }
    }
    
    var isFulfilled: Bool {
         extracted.isFullfilled 
    }
}
