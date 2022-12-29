//
//  PaymentHistoyViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/11/2022.
//

import Foundation
import Combine


class PaymentHistoyViewModel : ObservableObject {
    
    private lazy var useCase  : PaymentHistoryUseCase = .init(delegate: self)
    var transactionReceived : PassthroughSubject<HistoryTransactionModel,Never> = .init()
    var filteredReceived : PassthroughSubject<[HistoryTransactionModel],Never> = .init()

    @Published var tempTransactions : [HistoryTransactionModel] = .init()
    
    private func handleFetchedTransactions( _ fetched : HistoryTransactionModel){
        if !tempTransactions.contains(where: {$0.id == fetched.id}){
            tempTransactions.append(fetched)
        }
    }
    
    private func handleFilteredTransaction(_ filtered : [HistoryTransactionModel] ){
        tempTransactions =  filtered
    }
    
}

extension PaymentHistoyViewModel : PaymentHistoryInputType {
    func handleInput(_ input: PaymentHistoryInput) {
        switch input {
        case .fetchAllTransactions:
            useCase.fetchTransactions()
        case .fetch(let closedRange):
            useCase.filterPaymentHistory(in: closedRange, from: tempTransactions)
        }
    }
}

extension PaymentHistoyViewModel : PaymentHistoryOutputType {
    func handleOutput(_ output: PaymentHistoryOutput) {
        switch output {
        case .fetchedTransaction(let historyTransactionModel):
            handleFetchedTransactions(historyTransactionModel)
        case .filtered(let historyTransactionModel):
            handleFilteredTransaction(historyTransactionModel)
        }
    }
}
