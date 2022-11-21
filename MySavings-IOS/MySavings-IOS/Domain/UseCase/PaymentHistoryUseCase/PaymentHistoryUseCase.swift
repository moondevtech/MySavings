//
//  PaymentHistoryUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/11/2022.
//

import Foundation
import Combine 

class PaymentHistoryUseCase {
    
    @CurrentUser var user
    var subscriptions : Set<AnyCancellable> = .init()
    weak var delegate : PaymentHistoryOutputType?
    
    init(delegate: PaymentHistoryOutputType?) {
        self.delegate = delegate
    }
    
    func fetchTransactions(){
        user.userDataModel
            .cards
            .publisher
            .compactMap { card in
                card.budgets
            }
            .flatMap { budget in
                budget.publisher
                    .compactMap { model in
                        model.transactions?
                            .sorted(by: {$0.transactionDate < $1.transactionDate})
                    }
                    .flatMap { transactions in
                        transactions.publisher
                            .map({ data in
                                HistoryTransactionModel(transaction: data)
                            })
                            .flatMap(maxPublishers :.max(1)) { transactionData in
                                Just(transactionData)
                                    .delay(for: 0.2, scheduler: RunLoop.main)
                                    .eraseToAnyPublisher()
                            }
                    }
            }
            .sink {[weak self] transaction in
                self?.delegate?.handleOutput(.fetchedTransaction(transaction))
            }
            .store(in: &subscriptions)
        
    }
    
    func filterPaymentHistory(in range : ClosedRange<Date>, from history : [HistoryTransactionModel]){
        
        history
            .publisher
            .filter{ range.contains($0.transaction.transactionDate)}
            .collect()
            .sink {[weak self] transaction  in
                self?.delegate?.handleOutput(.filtered(transaction))
            }
            .store(in: &subscriptions)
    }
}
