//
//  TransactionUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine

class ExpensesTransactionUseCase {
    
    weak var delegate : ExpensesTransactionUseCaseDelegate?
    
    init(delegate: ExpensesTransactionUseCaseDelegate) {
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
            .flatMap(maxPublishers: .max(1)){
                Just($0)
                    .delay(for: 0.2, scheduler: RunLoop.main)
            }
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
                    .collect()
                    .map{ transactions in
                        var copy = cardModel
                        copy.cardData.transaction = transactions
                        return copy
                    }
                    .eraseToAnyPublisher()
            }
            .removeDuplicates()
            .collect()
            .eraseToAnyPublisher()
        
        delegate?.cardUsedForPayments(with: publisher)
    }
    
}
