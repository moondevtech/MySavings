//
//  AmountRemainingUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine

protocol AmountRemainingUseCaseDelegate : AnyObject {
    
    func onTransactionAmount(publisher : AnyPublisher<Double,Never>)
}

class AmountRemainingUseCase {
    
    weak var delegate : AmountRemainingUseCaseDelegate?
    
    
    init(delegate: AmountRemainingUseCaseDelegate? = nil) {
        self.delegate = delegate
    }
    
    func calculateTransactionAmount(input : AmountRemainingInput ){
        let transactionAmount = input.cardUser.cards
            .publisher
            .flatMap{ card in
                card.transaction
                    .publisher
                    .map{
                        $0.amount
                    }
                    .reduce(0) { $0 + $1}
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        delegate?.onTransactionAmount(publisher: transactionAmount)
    }
    
}
