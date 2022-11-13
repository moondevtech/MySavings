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
    var userRepository : UserRepositoryDelegate
    var subscriptions : Set<AnyCancellable> = .init()
    
    init(
        delegate: CardDetailUseCaseDelegate,
        userRepository : UserRepositoryDelegate =  UserRepository()
    ) {
        self.delegate = delegate
        self.userRepository = userRepository
    }
    
    func fetchCard(with id : String, from cards : [CreditCardDataModel]){
        cards
            .publisher
            .first(where: {$0.id == id })
            .map { model in
                let card =  CardModel(cardData: .init(
                    name: model.cardHolder,
                    cardNumber : model.cardNumber,
                    expired: model.expirationDate,
                    cvv : model.cvv,
                    type: model.creditCardType.rawValue
                )
                )
                
                return (card,model)
            }
            .sink {[weak self] cardModel in
                self?.delegate?.handleOutput(.fetchedCard(cardModel.0, cardModel.1))
            }
            .store(in: &subscriptions)
    }
    
    func fetchTransactions(_ cardModel : AnyPublisher<CreditCardDataModel,Never>){
        cardModel
            .flatMap { card in
                var dict = [BudgetDataModel : [TransactionDataModel]]()
                card.budgets?.forEach{ bdg in
                    dict[bdg] = bdg.transactions ?? []
                }
                return dict
                    .publisher
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink {[weak self] transaction in
                self?.delegate?.handleOutput(.fetchedTransactions(transaction))
            }
            .store(in: &subscriptions)
    }
    
    func saveTransaction(_ newTransaction : NewTransactionModel, cardData : CreditCardDataModel?){
        guard let cardData = cardData else {
            return
        }
        do{
            try userRepository.fetch()
                .first()
                .map { usercd in
                    (usercd.cards?.allObjects as? [CreditCardCD])?.first(where: {$0.id == cardData.id})
                }
                .map { cardcd in
                    (cardcd?.budgets?.allObjects as? [BudgetCD])?.first(where: {$0.name == newTransaction.budget})
                }
                .handleEvents(receiveOutput: {[weak self] budgetCd in
                    do{
                        let newTransactionCD =  TransactionsCD(context: PersistenceController.shared.context)
                        newTransactionCD.budget = budgetCd
                        newTransactionCD.amount = newTransaction.realAmount
                        newTransactionCD.transactionDate = newTransaction.date
                        newTransactionCD.transactionTitle = newTransaction.reason
                        newTransactionCD.id =  UUID().uuidString
                        
                        budgetCd?.addToTransactions(newTransactionCD)
                        
                        try PersistenceController.shared.save()
                                                                        
                    }catch{
                        self?.delegate?.handleOutput(.savedTransaction(.failure(error)))

                    }
                })
                .sink {[weak self] _ in
                    self?.delegate?.handleOutput(.savedTransaction(.success(true)))
                }
                .store(in: &subscriptions)
            
        }catch{
            self.delegate?.handleOutput(.savedTransaction(.failure(error)))
        }
    }
    
    
    func updateUser(){
        do{
            try userRepository
                .fetch()
                .sink(receiveValue: {[weak self] _ in
                    self?.delegate?.handleOutput(.userUpdated(.success(true)))
                })
                .store(in: &subscriptions)
        }catch{
            self.delegate?.handleOutput(.userUpdated(.failure(error)))

        }
    }
    
    func selectBudget(_ budget : BudgetDataModel, from budgets : [BudgetDataModel : [TransactionDataModel]]){
        budgets
            .publisher
            .map { pair -> Dictionary<BudgetDataModel, [TransactionDataModel]>.Element in
                var copy = pair
                if copy.key.isSelected {
                    copy.key.isSelected = false
                }else{
                    copy.key.isSelected =  copy.key.id ==  budget.id
                }
                return copy
            }
            .collect()
            .map{ elements -> [BudgetDataModel : [TransactionDataModel]] in
                var dict = [BudgetDataModel : [TransactionDataModel]]()
                elements.forEach { element in
                    dict[element.key] =  element.value
                }
                return dict
            }
            .sink{[weak self] dict in
                self?.delegate?.handleOutput(.transactionSelected(dict))
            }
            .store(in: &subscriptions)
  
    }
}
