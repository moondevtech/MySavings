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
    var transactionSavedEvents : PassthroughSubject<Bool,Never> = .init()

    var cardFound : CreditCardDataModel?
    var subscriptions : Set<AnyCancellable> = .init()
    @Published var transactions : [BudgetDataModel : [TransactionDataModel]] = .init()

    private func handleFetchedCard(_ cardModel : CardModel, cardData : CreditCardDataModel){
        self.cardFoundEvent.send(cardModel)
        self.cardFound = cardData
        handleInput(.fetchTransaction(cardData))
    }
    
    private func handleFetchedTransaction(_ transaction : [BudgetDataModel : [TransactionDataModel]]){
        self.transactions = transaction
        Log.i(content: transaction.keys)
    }
    
    private func handleSavedTransaction(_ result : Result<Bool, Error>){
        switch result {
        case .success(let success):
            transactionSavedEvents.send(success)
            handleInput(.updateUser)
        case .failure(let failure):
            Log.e(error: failure)
        }
    }
    
    private func handleUserUpdated(_ result : Result<Bool, Error>){
        switch result {
        case .success(_):
            handleInput(.fetchTransaction(cardFound!))
            transactionSavedEvents.send(true)
        case .failure(let failure):
            Log.e(error: failure)
        }
    }
    
}

extension CardDetailsScreenViewModel : CardDetailsVMType {
    
    func handleInput(_ input: CardDetailsInput) {
        switch input {
        case .fetchCard(let id):
            useCase.fetchCard(with: id, from: user[keyPath: \.userDataModel.cards])
        case .fetchTransaction(let card):
            useCase.fetchTransactions(Just(card).eraseToAnyPublisher())
        case .saveTransaction(let newTransaction):
            useCase.saveTransaction(newTransaction, cardData: cardFound)
        case .updateUser:
            useCase.updateUser()
        case .selectBudget(let budget):
            useCase.selectBudget(budget, from: transactions)
        }
    }
    
}

extension CardDetailsScreenViewModel : CardDetailUseCaseDelegate {
    
    func handleOutput(_ output: CardDetailsOutput) {
        switch output {
        case .fetchedCard(let card, let data):
            handleFetchedCard(card,cardData: data)
        case .fetchedTransactions(let transaction):
            handleFetchedTransaction(transaction)
        case .savedTransaction(let result):
            handleSavedTransaction(result)
        case .userUpdated(let result):
            handleUserUpdated(result)
        }
    }
    
    
}
