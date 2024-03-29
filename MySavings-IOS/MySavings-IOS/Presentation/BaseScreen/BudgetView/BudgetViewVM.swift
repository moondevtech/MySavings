//
//  BudgetViewVM.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 09/11/2022.
//

import Foundation
import Combine


class BudgetViewVM : ObservableObject {
    
    @CurrentUser var user
    private lazy var useCase : BudgetUseCase = BudgetUseCase(self)
    @Published var amountAllocated : Double = 0.0
    @Published var amounSpent: Double = 0.0
    @Published var percentSpent : Double = 0.0
    @Published var budgetDisplayType : BudgetDisplayType = .percentType
    var subscriptions : Set<AnyCancellable> = .init()
    
    private func handleFetchedBudget(amount : Double, spent : Double){
        self.amountAllocated = amount
        self.amounSpent = spent
        self.handleInput(.getPercent)
    }
    
}

extension BudgetViewVM : BudgetVMType{
    
    func handleInput(_ input: BudgetInput) {
        switch input {
        case .fetchBudget:
            useCase.getBuget(with: user[keyPath: \.userDataModel.cards])
        case .fetchBudgetByCardId(let cardId):
            useCase.getBuget(with: user[keyPath: \.userDataModel.cards].filter{ $0.id == cardId } )
        case .toggleDisplay:
            useCase.toggleDisplay(from: budgetDisplayType)
        case .getPercent:
            useCase.getPercent(with: $amounSpent.eraseToAnyPublisher(),
                               from: $amountAllocated.eraseToAnyPublisher()
            )
        }
    }
    
}

extension BudgetViewVM : BudgetUseCaseDelegate{
    
    func handleOutput(_ output: BudgetOutput) {
        switch output {
        case .budgetFetched(let amount, let spent):
            handleFetchedBudget(amount: amount, spent: spent)
        case .percentCalculated(let percent):
            self.percentSpent = percent
        case .displayToggled(let display):
            self.budgetDisplayType = display
        }
    }
    
}
