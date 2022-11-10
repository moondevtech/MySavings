//
//  CardDetailsUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 10/11/2022.
//

import Foundation
import Combine

class CardDetailsUseCase {
    
    weak var delegate : CardDetailUseCaseDelegate?
    var subscriptions : Set<AnyCancellable> = .init()
    init(delegate: CardDetailUseCaseDelegate) {
        self.delegate = delegate
    }
    
    func fetchCard(with id : String, from cards : [CreditCardDataModel]){
       cards
            .publisher
            .first(where: {$0.id == id })
            .map { card in
                CardModel(cardData: .init(
                    name: card.cardHolder,
                    cardNumber : card.cardNumber,
                    expired: card.expirationDate,
                    cvv : card.cvv,
                    type: card.creditCardType.rawValue
                    )
                )
            }
            .sink {[weak self] cardModel in
                self?.delegate?.handleOutput(.fetchedCard(cardModel))
            }
            .store(in: &subscriptions)
    }
    
    func fetchTransactions(_ cardModel : AnyPublisher<CardModel,Never>){
        cardModel
            .map(\.cardData.transaction)
            .flatMap{ transactions in
                transactions
                    .publisher
                    .eraseToAnyPublisher()
                    .flatMap(maxPublishers : .max(1)){
                        Just($0).delay(for: 0.5, scheduler: DispatchQueue.main)
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink {[weak self] transaction in
                self?.delegate?.handleOutput(.fetchedTransactions(transaction))
            }
            .store(in: &subscriptions)
    }
}
