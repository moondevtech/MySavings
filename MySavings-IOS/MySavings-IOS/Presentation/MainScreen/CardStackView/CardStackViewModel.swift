//
//  CardStackViewModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation
import Combine

typealias CardFetched = Result<AnyPublisher<[CardModel],Never>, Never>

class CardStackViewModel : ObservableObject {
    
    @CurrentUser var user
    private lazy var useCase : CardListUseCase = .init(delegate: self)
    var subscriptions : Set<AnyCancellable> = .init()
    var toCarddetailsEvent : PassthroughSubject<CardModel,Never> = .init()
    var userHasChanged : PassthroughSubject<Bool,Never> = .init()
    @Published var cards : [CardModel] = .init()
    
    
    private func observeUser(){
        $user.sink {[weak self] user in

        }
        .store(in: &subscriptions)
    }
    
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
    
}




extension CardStackViewModel : CardListVMType {
    func handleInput(_ input: CardListVMInput) {
        switch input {
        case .fetchCards:
            useCase.fetchCards(user[keyPath: \.userDataModel.cards])
        case .toCardDetails(let card):
            useCase.navigateToCardDetails(Just(card).eraseToAnyPublisher())
        }
    }
}

extension CardStackViewModel : CardListUseCaseDelegate {
    func handleOuput(_ output: CardListVMOutput) {
        switch output {
        case .fetchCard(let result):
            handleCardFetched(result)
        case .toCardDetails(let cardModel):
            toCarddetailsEvent.send(cardModel)
        }
    }
}
