//
//  CardDetailsScreenViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import Foundation
import Combine


class CardDetailsScreenViewModel  : ObservableObject{
    
    @CurrentUser var user
    private lazy var useCase : CardDetailsUseCase = .init(delegate: self)
    var cardFoundEvent : PassthroughSubject<CardModel,Never> = .init()
    var subscriptions : Set<AnyCancellable> = .init()
    @Published var transactions : [TransactionData] = .init()

    private func handleFetchedCard(_ cardModel : CardModel){
        self.cardFoundEvent.send(cardModel)
        handleInput(.fetchTransaction(cardModel))
    }
    
    private func handleFetchedTransaction(_ transaction : TransactionData){
        self.transactions.append(transaction)
    }
    
}

extension CardDetailsScreenViewModel : CardDetailsVMType {
    
    func handleInput(_ input: CardDetailsInput) {
        switch input {
        case .fetchCard(let id):
            useCase.fetchCard(with: id, from: user[keyPath: \.cards])
        case .fetchTransaction(let card):
            useCase.fetchTransactions(Just(card).eraseToAnyPublisher())
        }
    }
    
}

extension CardDetailsScreenViewModel : CardDetailUseCaseDelegate {
    
    func handleOutput(_ output: CardDetailsOutput) {
        switch output {
        case .fetchedCard(let cardModel):
            handleFetchedCard(cardModel)
        case .fetchedTransactions(let transaction):
            handleFetchedTransaction(transaction)
        }
    }
    
    
}
