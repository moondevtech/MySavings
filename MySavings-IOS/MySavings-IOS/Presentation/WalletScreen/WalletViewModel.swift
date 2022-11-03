//
//  WalletViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine

class WalletViewModel : ObservableObject{
    
    @Published var hideExpensesView : Bool = false
    @Published var budgetLeft : Double = 0.0
    @Published var cardUser : CardUser = .init()
    @Published var expensesGraphData : [ExpenseGraphModel] = .init()
    @Published var cardModel : [CardModel] = .init()
    @Published var cardUsedForPayment : [CardModel] = .init()
    @Published var selectedCardTransactions : [TransactionData] = .init()
    @Published var selectedCard : CardModel = .init(cardData: CreditCardData(name: ""))
    var subsriptions = Set<AnyCancellable>()
    var selectedCardEvent  = PassthroughSubject<CardModel, Never>()
    
    lazy var useCase : CardSelectionUseCase = CardSelectionUseCase(delegate: self)
    lazy var useCaseAmount : AmountRemainingUseCase = AmountRemainingUseCase(delegate: self)
    lazy var useCaseTransaction : TransactionUseCase = TransactionUseCase(delegate: self)
    
    
    
    init(){
        mockSetup()
        calculateCurrentTransactionAmount(input: AmountRemainingInput(cardUser: cardUser))
        getTransactions()
    }
    
    private func mockSetup(){
        cardUser.cards.forEach { card in
            cardModel.append(CardModel(cardData:card))
        }
    }
    
    func selectCard(_ cardModel : CardModel){
        handleCardInput(input: .select(Just(cardModel)))
        
    }
    
    func unselectCar(){
        handleCardInput(input: .select(Just(CardModel(cardData: .init(name: "")))))
    }
    
    func getTransactions(){
        handleTransactions(with: TransactionInput.fetch(cardModel))
    }
    
    func findSelectedPaymentsForDate(_ date : String){
        handleTransactions(with: .filter((cardModel,date)))
    }
    
}


extension WalletViewModel : CardSelectorType{
    
    typealias Card = CardModel
    
    func handleCardInput(input: CardSelectionInput) {
        switch input {
        case .select(let just):
            useCase.selectCard(with: just.eraseToAnyPublisher(), compareto: cardModel)
        case .unselect(let just):
            useCase.selectCard(with: just.eraseToAnyPublisher(), compareto: cardModel)
        }
    }
}

extension WalletViewModel : CardSelectionUseCaseDelegate{
    
    func toggleCardState(publisher: AnyPublisher<CardModel, Never>) {
        publisher
            .assign(to: &$selectedCard)
    }
    
    func handleTransactionData(publisher: AnyPublisher<TransactionData, Never>) {
        publisher
            .sink { transactionData in
                if !self.selectedCard.name.isEmpty{
                    self.selectedCardTransactions.append(transactionData)
                }else{
                    self.selectedCardTransactions = []
                }
            }
            .store(in: &subsriptions)
    }
    
    func updateWalletCards(publisher: AnyPublisher<[CardModel], Never>) {
        publisher
            .zip($selectedCard)
            .sink { cards, selectedCard in
                var received = cards
                if !selectedCard.name.isEmpty{
                    received.append(selectedCard)
                }
                self.cardModel = received.sorted(by: {$0.name > $1.name})
            }
            .store(in: &subsriptions)
    }
    
    
}


extension WalletViewModel  : AmountRemainCounterType {
    
    typealias Input = AmountRemainingInput
    
    func calculateCurrentTransactionAmount(input: AmountRemainingInput) {
        useCaseAmount.calculateTransactionAmount(input: input)
    }
    
}


extension WalletViewModel : AmountRemainingUseCaseDelegate {
    
    func onTransactionAmount(publisher: AnyPublisher<Double, Never>) {
        publisher
            .sink { transactionsAmount in
                let remaining = self.cardUser.monthAllowedBudget - transactionsAmount
                self.budgetLeft = remaining
            }
            .store(in: &subsriptions)
    }
}


extension WalletViewModel : TransactionType {
    
    func handleTransactions(with input: TransactionInput) {
        switch input {
        case .fetch(let just):
            useCaseTransaction.fetchTransactions(with: just)
        case .filter(let just):
            useCaseTransaction.filterCard(with: just)
            
        }
    }
}

extension WalletViewModel : TransactionUseCaseDelegate {
    func graphTransactions(with result: AnyPublisher<[ExpenseGraphModel], Never>) {
        result
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                self.expensesGraphData = result.sorted(by: {$0.transaction.date < $1.transaction.date})
            })
            .store(in:&subsriptions)
    }
    
    func cardUsedForPayments(with result: AnyPublisher<[CardModel], Never>) {
        result
            .receive(on: DispatchQueue.main)
            .assign(to: &$cardUsedForPayment)
        
    }
    
    
}
