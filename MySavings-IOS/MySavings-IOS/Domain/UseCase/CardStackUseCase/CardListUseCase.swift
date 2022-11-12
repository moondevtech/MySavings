//
//  CardListUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation
import Combine


class CardListUseCase {
    
    weak var delegate : CardListUseCaseDelegate?
    var subscriptions =  Set<AnyCancellable>()
    
    init(delegate: CardListUseCaseDelegate) {
        self.delegate = delegate
    }
    
    func fetchCards(_ data : [CreditCardDataModel]) {
        data
            .publisher
            .map { card in
                CardModel(
                    id: card.id,
                    cardData: .init(
                        name: card.cardHolder,
                        cardNumber : card.cardNumber,
                        expired: card.expirationDate,
                        cvv : card.cvv,
                        type: card.creditCardType.rawValue
                    )
                )
            }
            .collect()
            .sink {[weak self] cardModel in
                self?.delegate?.handleOuput(
                    .fetchCard(
                        .success(
                            Just(cardModel).eraseToAnyPublisher()
                        )
                    )
                )
            }
            .store(in: &subscriptions)
    }
    
    func navigateToCardDetails(_ data : AnyPublisher<CardModel,Never>){
        data
            .delay(for: 0.4, scheduler: DispatchQueue.main)
            .sink {[weak self] card in
                self?.delegate?.handleOuput(.toCardDetails(card))
            }
            .store(in: &subscriptions)
        
    }
    
}
