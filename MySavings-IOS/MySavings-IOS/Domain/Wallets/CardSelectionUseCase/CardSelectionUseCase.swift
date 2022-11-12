//
//  CardSelectionUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine

protocol CardSelectionUseCaseDelegate : AnyObject {
    
    func toggleCardState(publisher : AnyPublisher<CardModel,Never>)
    
    func handleTransactionData(publisher : AnyPublisher<TransactionData,Never>)
    
    func updateWalletCards(publisher : AnyPublisher<[CardModel], Never>)
}

class CardSelectionUseCase {
    
    weak var delegate : (any CardSelectionUseCaseDelegate)?
    
    init(delegate: CardSelectionUseCaseDelegate) {
        self.delegate = delegate
    }
    
    func selectCard(with cardModel : AnyPublisher<CardModel,Never>, compareto cards : [CardModel]){
        let publisher =  cardModel
            .receive(on: DispatchQueue.main)
            .zip(cards.publisher.collect())
            .share()
        
        
        
       let stateToggler = publisher
            .map{selectedCard, _ in
                let isEmpty = selectedCard.name.isEmpty
                var copy = selectedCard
               // copy.isSelected = !isEmpty
                return copy
            }
            .eraseToAnyPublisher()
        
        delegate?.toggleCardState(publisher: stateToggler)
        
        
        let transactionHandler = publisher
            .map(\.0)
            .flatMap { cardModel -> AnyPublisher<TransactionData,Never> in
                cardModel.cardData.transaction
                    .publisher
                    .removeDuplicates()
                    .eraseToAnyPublisher()
            }
            .zip(Timer
                .publish(every: 0.3, on: RunLoop.main, in: .default).autoconnect())
            .map(\.0)
            .eraseToAnyPublisher()
        
        delegate?.handleTransactionData(publisher: transactionHandler)
        
        
        let updateWallets = publisher
            .flatMap{ selectedCard, cardModels -> AnyPublisher<[CardModel], Never> in
                return cardModels.filter{ $0 != selectedCard }
                    .publisher
                    .map { model in
                        var copy = model
                      //  copy.isSelected = false
                        return copy
                    }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        delegate?.updateWalletCards(publisher: updateWallets)
    }
    
}
