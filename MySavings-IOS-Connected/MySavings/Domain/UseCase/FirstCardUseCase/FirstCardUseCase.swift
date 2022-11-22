//
//  FirstCardUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 08/11/2022.
//

import Foundation
import Combine

class FirstCardUseCase {
    
    let userRepo : UserRepositoryDelegate
    let budgetRepo : BudgetCategoryRepositoryDelegate
    weak var delegate : FirstCardUseCaseDelegate?
    var subscriptions : Set<AnyCancellable> = .init()
    
    init(
        userRepo: UserRepositoryDelegate,
        budgetRepo: BudgetCategoryRepositoryDelegate,
        delegate : FirstCardUseCaseDelegate
    ) {
        self.userRepo = userRepo
        self.budgetRepo = budgetRepo
        self.delegate = delegate
    }
    
    func addCard(with cardHolder : CardHolder, and budgets  : AuthBudgets, for currentUser : String){
        
        let creditCardCd =  CreditCardCD(context: PersistenceController.shared.container.viewContext)
        creditCardCd.cardNumber = cardHolder.cardnumber
        creditCardCd.cvv = cardHolder.cvv
        creditCardCd.expirationDate = cardHolder.expirationDate
        creditCardCd.cardHolder = cardHolder.cardholder
        creditCardCd.cardType = cardHolder.cardType.rawValue
        creditCardCd.id = cardHolder.id
        
        let budgets = budgets.budgets.map { authBudget in
            let budgetCd = BudgetCD(context: PersistenceController.shared.container.viewContext)
            budgetCd .id = authBudget.id
            budgetCd.name = authBudget.title
            budgetCd.amountSpent = 0
            budgetCd.maxAmount = authBudget.realAmount()
            budgetCd.fromCard = creditCardCd
            return budgetCd
        }
        
        creditCardCd.budgets = NSSet(array: budgets)
        
        do{
            try userRepo.fetch(with: currentUser)
                .receive(on: DispatchQueue.main)
                .sink {[weak self] userCd in
                    userCd.addToCards(creditCardCd)
                    let budgetsModel = budgets.map{$0.toBudgetDataModel()}
                    self?.delegate?.handleOutput(.addCard(.success(budgetsModel)))
                }
                .store(in: &subscriptions)
        }catch{
            delegate?.handleOutput(.addCard(.failure(.error(error))))
        }
    }
    
    func addCategorie(_ budgets : [BudgetDataModel]){
        let categories =  budgets.map { dataModel in
            BudgetCategoryDataModel(categoryName: dataModel.name, createdAt: .now)
        }

        do{
            try categories.forEach { category in
                try budgetRepo.create(category)
            }
        }catch{
            delegate?.handleOutput(.addCategories(.failure(.error(error))))
        }
        delegate?.handleOutput(.addCategories(.success(true)))
    }
}
