//
//  BudgetUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation
import Combine

class BudgetUseCase {
    
    weak var delegate : BudgetUseCaseDelegate?
    var subscriptions : Set<AnyCancellable> = .init()
    
    init(_ delegate : BudgetUseCaseDelegate){
        self.delegate = delegate
    }

    func getBuget(with cards : [CreditCardDataModel] ){
        let userBudget = cards
            .publisher
            .compactMap({ card in
                card.budgets
            })
        
       let amounts = userBudget.flatMap{ budgets in
            budgets
                .publisher
                .eraseToAnyPublisher()
                .map(\.maxAmount)
                .reduce(0.0) { acc, next in
                    acc + next
                }
        }
        .collect()
        .map{amounts in
            amounts.reduce(0.0) { counter, value  in counter + value }
        }
        
        let spent =  userBudget
            .flatMap { budgets in
                budgets
                    .publisher
                    .eraseToAnyPublisher()
            }
            .compactMap(\.transactions)
            .flatMap { transactions in
                transactions
                    .publisher
                    .eraseToAnyPublisher()
                    .map(\.amount)
                    .reduce(0) { current, next in
                        current + next
                    }
            }
            .eraseToAnyPublisher()


        
        Publishers.Zip(amounts, spent)
            .sink {[weak self] amount, spent in
                self?.delegate?.handleOutput(.budgetFetched(amount, spent))
            }
            .store(in: &subscriptions)
    }
    
    
    func getPercent(with spent : AnyPublisher<Double, Never>, from amount : AnyPublisher<Double,Never>) {
        amount
            .zip(spent)
            .map{max , spent  in
                return 100 * spent / max
            }
            .sink{[weak self] percent in
                self?.delegate?.handleOutput(.percentCalculated(percent))
            }
            .store(in: &subscriptions)
    }
    
    func toggleDisplay(from displayType : BudgetDisplayType){
        switch displayType {
        case .percentType:
            delegate?.handleOutput(.displayToggled(.amountType))
        case .amountType:
            delegate?.handleOutput(.displayToggled(.percentType))
            
        }
    }

}

