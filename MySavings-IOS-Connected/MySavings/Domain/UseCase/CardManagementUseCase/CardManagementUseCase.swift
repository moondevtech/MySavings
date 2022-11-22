//
//  CardListUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation
import Combine


class CardManagementUseCase {
    
    weak var delegate : CardManagementUseCaseDelegate?
    var subscriptions =  Set<AnyCancellable>()
    var userRepository : UserRepositoryDelegate
    
    init(delegate: CardManagementUseCaseDelegate, userRepository : UserRepositoryDelegate =  UserRepository()) {
        self.delegate = delegate
        self.userRepository =  userRepository
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
    
    
    func selectCard(_ card : CardModel, from all : [CardModel] ){
        all.publisher
            .map { model in
                var  copy = model
                copy.isSelected =  model.id ==  card.id
                return copy
            }
            .collect()
            .sink{[weak self] cards in
                self?.delegate?.handleOuput(.updateCards(cards))
            }
            .store(in: &subscriptions)
    }
    
    func showCardHolder(_ card : CardModel ){
        Just(card)
            .map { model in
              return  CardHolder(
                    id: card.id, cardnumber: card.cardNumber, cardholder: card.cardData.name, cvv: card.cardData.cvv, expirationDate: card.cardData.expired)
            }
            .sink{[weak self] card in
                self?.delegate?.handleOuput(.selectedCard(card))
            }
            .store(in: &subscriptions)
    }
    
    
    func removeCard(with id : String) {
        do {
            try userRepository.removeCard(id)
                .sink{[weak self] success in
                    self?.delegate?.handleOuput(.cardsDeleted(.success((success, id))))
                }
                .store(in: &subscriptions)
        }catch {
            delegate?.handleOuput(.cardsDeleted(.failure(error)))
        }
    }
    
}
