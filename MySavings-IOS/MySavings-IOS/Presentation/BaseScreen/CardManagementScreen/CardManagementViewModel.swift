//
//  CardStackViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation
import Combine


class CardManagementViewModel : ObservableObject {
    
    @CurrentUser var user
    private lazy var useCase : CardManagementUseCase = .init(delegate: self)
    var subscriptions : Set<AnyCancellable> = .init()
    var cardHolderEvent : PassthroughSubject<CardHolder,Never> = .init()
    @Published var cards : [CardModel] = .init()
    

    private func handleCardFetched(_ fetched : CardFetched){
        switch fetched {
        case .success(let cards):
            cards
                .flatMap{cards in
                    cards
                        .publisher
                        .eraseToAnyPublisher()
                        .flatMap(maxPublishers : .max(1)){
                            Just($0).delay(for: 0.5, scheduler: DispatchQueue.main)
                        }
                        .eraseToAnyPublisher()
                }
                .sink {[weak self] cardModel in
                    self?.cards.append(cardModel)
                }
                .store(in: &subscriptions)
        }
    }
    
    private func handleUpdatedCards(_ cards : [CardModel]){
        self.cards = cards
        if let selectedCard = cards.first(where: \.isSelected){
            handleInput(.showCardHolder(selectedCard))
        }
    }
    
    private func handleCardDeletion(_ result : SuccessError){
        switch result{
        case .success(let isRemoved):
            if isRemoved.0{
                Log.s(content: "Card removed")
                cards.removeAll(where: {$0.id == isRemoved.1})
            }else{
                Log.w(content: "Could not remove card")
            }
        case .failure( let error):
            Log.e(error: error)
        }
    }
}




extension CardManagementViewModel : CardManagementType {
    func handleInput(_ input: CardManagementInput) {
        switch input {
        case .fetchCards:
            useCase.fetchCards(user[keyPath: \.userDataModel.cards])
        case .selectCard(let card):
            useCase.selectCard(card, from : cards)
        case .showCardHolder(let card):
            useCase.showCardHolder(card)
        case .deleteCard(let cardId):
            useCase.removeCard(with: cardId)
        }
    }
}

extension CardManagementViewModel : CardManagementUseCaseDelegate {
    func handleOuput(_ output: CardManagementOutput) {
        switch output {
        case .fetchCard(let result):
            handleCardFetched(result)
        case .selectedCard(let holder):
            cardHolderEvent.send(holder)
        case .updateCards(let cards):
            handleUpdatedCards(cards)
        case .cardsDeleted(let result):
            handleCardDeletion(result)
        }
    }
}
