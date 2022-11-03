//
//  TransactionUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine

enum TransactionInput {
    
   case fetch([CardModel]), filter(([CardModel],String))
    
}

protocol TransactionType {
    
    func handleTransactions(with input : TransactionInput)
    
}

protocol TransactionUseCaseDelegate : AnyObject {
    
    func graphTransactions(with result : AnyPublisher<[ExpenseGraphModel], Never>)
    
    func cardUsedForPayments(with result : AnyPublisher<[CardModel], Never>)

}


class TransactionUseCase {
    
    weak var delegate : TransactionUseCaseDelegate?
    
    init(delegate: TransactionUseCaseDelegate?) {
        self.delegate = delegate
    }
    
    func fetchTransactions(with input : [CardModel]) {
        let publisher = input
            .publisher
            .flatMap { model in
                model.cardData.transaction
                    .publisher
                    .map { transaction in
                        ExpenseGraphModel(
                            transaction: transaction,
                            cardColor: .creditCardColor(model.cardData),
                            cardNumber: model.cardData.cardNumber
                        )
                    }
                    .eraseToAnyPublisher()
            }
            .collect()
            .eraseToAnyPublisher()
        
        delegate?.graphTransactions(with: publisher)
    }
    
    func filterCard(with input : ([CardModel],String)){
        let publisher = input.0
            .publisher
            .flatMap { cardModel in
                cardModel.cardData.transaction
                    .publisher
                    .filter {$0.dayDateString == input.1}
                    .map{ _ in
                        cardModel
                    }
                    .eraseToAnyPublisher()
            }
            .collect()
            .eraseToAnyPublisher()
        
        delegate?.cardUsedForPayments(with: publisher)
    }
    
}
