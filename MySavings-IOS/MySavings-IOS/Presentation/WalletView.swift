//
//  WalletView.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 31/10/2022.
//

import SwiftUI
import Combine
import Charts

struct WalletView: View {
    
    @StateObject var walletViewModel : WalletViewModel = .init()
    @State var showBigCard : Bool = false
    @State var showPaymentsForDate : Bool = false
        
    var body: some View {
        ScrollView{
                        
            MonthAllowedBudgetView()
            
            if showBigCard{
                SelectedCardView(card: walletViewModel.selectedCard)
            }else{
                VStack{
                    ExpensesView()
                    CardListView()
                        .padding(.top, 40)
                    
                }
                .animation(.linear, value: walletViewModel.selectedCardTransactions)
            }
            
        }
        .environmentObject(walletViewModel)
        .animation(.linear, value: showBigCard)
        .preferredColorScheme(.dark)
        .onReceive(walletViewModel.$selectedCard) { card in
            showBigCard = card.isSelected
        }
        .onReceive(walletViewModel.$cardUsedForPayment) { cards in
            guard !cards.isEmpty else {return}
            showPaymentsForDate = !cards.isEmpty
        }
        .sheet(isPresented: $showPaymentsForDate) {
            SelectedCardsView(cards: walletViewModel.cardUsedForPayment)
        }
    }
}

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
    
    init(){
        cardUser.cards.forEach { card in
            cardModel.append(CardModel(cardData:card))
        }
        observe()
    }
    
    func observe(){
        let publisher =  selectedCardEvent
            .receive(on: DispatchQueue.main)
            .zip($cardModel)
            .share()
        
        publisher
            .map{selectedCard, _ in
            let isEmpty = selectedCard.name.isEmpty
            var copy = selectedCard
            copy.isSelected = !isEmpty
            return copy
        }
        .assign(to: &$selectedCard)
        
        publisher
            .map(\.0)
            .flatMap({ cardModel -> AnyPublisher<TransactionData,Never> in
                cardModel.cardData.transaction
                    .publisher
                    .removeDuplicates()
                    .eraseToAnyPublisher()
            })
            .zip(Timer
                .publish(every: 0.3, on: RunLoop.main, in: .default).autoconnect())
            .sink { transactionData in
                if !self.selectedCard.name.isEmpty{
                    self.selectedCardTransactions.append(transactionData.0)
                }else{
                    self.selectedCardTransactions = []
                }
            }
            .store(in: &subsriptions)
        
        publisher
            .receive(on: DispatchQueue.main)
            .flatMap{ selectedCard, cardModels -> AnyPublisher<[CardModel], Never> in
                return cardModels.filter{ $0 != selectedCard }
                    .publisher
                    .map { model in
                        var copy = model
                        copy.isSelected = false
                        return copy
                    }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .sink { cards in
                var received = cards
                if !self.selectedCard.name.isEmpty{
                    received.append(self.selectedCard)
                }
                self.cardModel = received.sorted(by: {$0.name > $1.name})
            }
            .store(in: &subsriptions)
        
        
        cardUser.cards
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
            .sink { transactionsAmount in
                let remaining = self.cardUser.monthAllowedBudget - transactionsAmount
                self.budgetLeft = remaining
            }
            .store(in: &subsriptions)
        
        
    }
    
    func selectCard(_ cardModel : CardModel){
        selectedCardEvent.send(cardModel)
    }
    
    func unselectCar(){
        selectedCardEvent.send(CardModel(cardData: .init(name: "")))
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

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
