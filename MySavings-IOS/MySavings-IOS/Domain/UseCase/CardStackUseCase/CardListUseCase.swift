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
    var userRepository : UserRepositoryDelegate
    
    init(
        delegate: CardListUseCaseDelegate,
        userRepository : UserRepositoryDelegate =  UserRepository()
    ) {
        self.delegate = delegate
        self.userRepository = userRepository
    }
    
    func updateUser(){
        do{
            try userRepository
                .fetch()
                .sink(receiveValue: { [weak self] _ in
                    self?.delegate?.handleOuput(.userUpdated)
                })
        }catch{
            Log.e(error: error)
        }
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
    
    func selectCard(_ card : CardModel, from cards : [CardModel]){
        cards
            .publisher
            .map { cm in
                var copy = cm
                if copy.isSelected {
                    copy.isSelected = false
                }else{
                    copy.isSelected = card.id == cm.id
                }
                return copy
            }
            .collect()
            .sink{ [weak self] cards in
                self?.delegate?.handleOuput(.updateCards(cards))
            }
            .store(in: &subscriptions)
        
    }
    
    func newBudget(_ budget : NewBudgetModel){
        
        let budgetsPublisher = budget.cardId
            .map { cardId in
                NewBudgetModel(reason: budget.reason, amount: budget.amount, cardId: [cardId])
            }
        
        do {
            try  userRepository
                .fetch()
                .map { usercd ->  [CreditCardCD]  in
                    return (usercd.cards?.allObjects as? [CreditCardCD]) ?? []
                }
                .handleEvents(receiveOutput: { [weak self] cardcds in

                    budgetsPublisher.forEach { budget in

                        cardcds.forEach { card in

                            if card.id == budget.cardId.first!{
                                let budgetCd =  BudgetCD(context: PersistenceController.shared.context)
                                budgetCd.amountSpent = 0.0
                                budgetCd.maxAmount = budget.realAmount
                                budgetCd.name = budget.reason
                                budgetCd.fromCard = card
                                
                                card.addToBudgets(budgetCd)
                                
                                Log.i(content: "\(card.cardHolder!) is adding budget...")
                            }
                        }
                    }
                    do{
                        try PersistenceController.shared.save()
                        Log.s(content: "Save new budget \(budget.reason)")
                    }catch{
                        Log.e(error: error)
                        self?.delegate?.handleOuput(.newBudgetsAdded(.failure(error)))
                    }
                })
                .sink{ [weak self] _ in
                    self?.delegate?.handleOuput(.newBudgetsAdded(.success(true)))
                }
                .store(in: &subscriptions)
            
            
        }catch{
            Log.e(error: error)
            self.delegate?.handleOuput(.newBudgetsAdded(.failure(error)))
        }
    }
    
}
