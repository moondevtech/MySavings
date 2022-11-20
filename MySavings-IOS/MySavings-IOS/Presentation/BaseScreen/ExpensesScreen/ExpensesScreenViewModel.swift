//
//  WalletViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine

class ExpensesScreenViewModel : ObservableObject{
    
    @Published var expensesGraphData : [ExpenseGraphModel] = .init()
    @Published var cardModels : [CardModel] = .init()
    var subsriptions = Set<AnyCancellable>()
    var selectedCardEvent  = PassthroughSubject<CardModel, Never>()
    var cardUsedForPayment : PassthroughSubject<[CardModel],Never> = .init()
    lazy var useCaseTransaction : ExpensesTransactionUseCase = ExpensesTransactionUseCase(delegate: self)
    

    func getTransactions(_ cards : [CardModel]){
        cardModels = cards
        handleTransactions(with: .fetch(cards))
    }
    
    func findSelectedPaymentsForDate(_ date : String){
        handleTransactions(with: .filter((cardModels,date)))
    }
    
}


extension ExpensesScreenViewModel : ExpensesTransactionType {
    
    func handleTransactions(with input: ExpensesTransactionInput) {
        switch input {
        case .fetch(let just):
            useCaseTransaction.fetchTransactions(with: just)
        case .filter(let just):
            useCaseTransaction.filterCard(with: just)
            
        }
    }
}

extension ExpensesScreenViewModel : ExpensesTransactionUseCaseDelegate {
    func graphTransactions(with result: AnyPublisher<ExpenseGraphModel, Never>) {
        result
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                self.expensesGraphData.append(result)
                self.expensesGraphData = self.expensesGraphData.sorted(by: {$0.transaction.date < $1.transaction.date})
            })
            .store(in:&subsriptions)
    }
    
    func cardUsedForPayments(with result: AnyPublisher<[CardModel], Never>) {
        result
            .receive(on: DispatchQueue.main)
            .sink{[weak self] cards in
                self?.cardUsedForPayment.send(cards)
            }
            .store(in: &subsriptions)
    }
    
    
}
