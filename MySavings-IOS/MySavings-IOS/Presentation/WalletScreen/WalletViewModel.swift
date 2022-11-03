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
    lazy var useCaseTransaction : AmountRemainingUseCase = AmountRemainingUseCase(delegate: self)

    
    init(){
        mockSetup()
        calculateCurrentTransactionAmount(input: AmountRemainingInput(cardUser: cardUser))
    }
    
    private func mockSetup(){
        cardUser.cards.forEach { card in
            cardModel.append(CardModel(cardData:card))
        }
    }
    
    func selectCard(_ cardModel : CardModel){
        selectCard(input: .select(Just(cardModel)))

    }
    
    func unselectCar(){
        selectCard(input: .select(Just(CardModel(cardData: .init(name: "")))))
    }
    
    func handleSwipeDelay(){
        $hideExpensesView
            .receive(on: DispatchQueue.main)
            .zip(Timer.publish(every: 1.5, on: .main, in: .common).autoconnect())
            .sink { isHidden, timer in
        
            }
            .store(in: &subsriptions)
    }
    
    func getTransactions(){
        cardModel
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
            .sink(receiveValue: { result in
                self.expensesGraphData = result.sorted(by: {$0.transaction.date < $1.transaction.date})
            })
            .store(in:&subsriptions)
    }
    
    func findSelectedPaymentsForDate(_ date : String){
        cardModel
            .publisher
            .flatMap { card in
                card.cardData.transaction
                    .publisher
                    .filter{$0.dayDateString == date}
                    .map {_ in
                        return card
                    }
                    .eraseToAnyPublisher()
            }
            .collect()
            .assign(to: &$cardUsedForPayment)
    }
    
}


extension WalletViewModel : CardSelectorType{
    
    typealias Card = CardModel

    func selectCard(input: CardSelectionInput) {
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
                    received.append(self.selectedCard)
                }
                self.cardModel = received.sorted(by: {$0.name > $1.name})
            }
            .store(in: &subsriptions)
    }
    

}


extension WalletViewModel  : AmountRemainCounterType {
    
    typealias Input = AmountRemainingInput

    func calculateCurrentTransactionAmount(input: AmountRemainingInput) {
        useCaseTransaction.calculateTransactionAmount(input: input)
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
