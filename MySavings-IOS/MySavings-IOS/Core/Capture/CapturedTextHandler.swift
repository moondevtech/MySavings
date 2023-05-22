//
//  CapturedTextHandler.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 15/05/2023.
//

import Foundation
import Combine

protocol CapturedTextHandlerProtocol : AnyObject {
    func onCapturedText(text: String)
}

protocol OnCapturedCardResultProtocol : AnyObject {
    
    func onCaptureCard(card: CapturedTextHandler.CapturedCard)
}

class CapturedTextHandler {
    
    private let namePattern = "^[\\p{L}'-][\\p{L}' -]{1,25}$"
    
    struct CapturedCard {
        var holder         : String = ""
        var cardnumber     : String = ""
        var expirationDate: Date = .now
        var cardType       : CardType?
    }
    
    var subscriptions: Set<AnyCancellable> = .init()
    weak var delegate : OnCapturedCardResultProtocol?
    @Published private var capturedCard: CapturedCard = .init()
    
    init(delegate : OnCapturedCardResultProtocol?) {
        self.delegate = delegate
        $capturedCard
            .filter {
                !$0.holder.isEmpty &&
                !$0.cardnumber.isEmpty &&
                $0.expirationDate < Date.now &&
                $0.cardType != nil
            }
            .receive(on: DispatchQueue.main)
            .sink {[weak self] card in
                self?.delegate?.onCaptureCard(card: card)
                self?.capturedCard = .init()
            }
            .store(in: &subscriptions)
    }
    
    private func checkCardNumber(text: String) {
        let length = text.count
        guard length > 8 && length < 20 else { return }
        let (type, formatted, isValid) = CardMatcher.shared.checkCardNumber(text)
        guard isValid else { return }
        capturedCard.cardnumber = formatted
        capturedCard.cardType = type
    }
    
    private func checkDate(text: String) {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "MM/YY"
        if let date = dateFormatter.date(from: text) {
            capturedCard.expirationDate = date
        }
    }
    
    private func checkName(text: String) {
        if let expression = try? NSRegularExpression(pattern: "^[A-Z]+ [A-Z]+$") {
            let range = NSRange(location: 0, length: text.utf16.count)
            if let _ = expression.firstMatch(in: text, options: [], range: range) {
                capturedCard.holder = text
            }
        }
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
    
}

extension CapturedTextHandler: CapturedTextHandlerProtocol {
    
    func onCapturedText(text: String) {
        checkCardNumber(text: text)
        checkDate(text: text)
        checkName(text: text)
    }
    
}
