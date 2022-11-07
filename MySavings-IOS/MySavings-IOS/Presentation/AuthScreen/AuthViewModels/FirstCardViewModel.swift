//
//  File.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation
import Combine
import SwiftUI
import CoreData

typealias AddCardOutput = Result<[BudgetDataModel], FirstCardError>
typealias AddCategoryOutput = Result<Bool, FirstCardError>


enum FirstCardInput {
    case addCard(CardHolder, AuthBudgets), addCategory([BudgetDataModel])
}

enum FirstCardOutput {
    case addCard(AddCardOutput), addCategories(AddCategoryOutput)
}

enum FirstCardError : LocalizedError {
    case empty, error(Error)
}

protocol FirstCardType {
    
    func handleInput(_ input : FirstCardInput)
    
}

protocol FirstCardUseCaseDelegate : AnyObject {
    
    func handleOutput(_ output : FirstCardOutput)
}


class FirstCardUseCase {
    
    @Environment(\.managedObjectContext) var context : NSManagedObjectContext

    
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
                .print()
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



class FirstCardViewModel : ObservableObject {
    
    private var currentUser : UserDataModel!
    let userRepository : UserRepositoryDelegate
    let budgetRepository : BudgetCategoryRepositoryDelegate
    lazy var useCase = FirstCardUseCase(userRepo: userRepository, budgetRepo: budgetRepository, delegate: self)
    var addCardRegistrationComplete  : PassthroughSubject<Bool,Never> = .init()
    
    init(
        userRepository: UserRepositoryDelegate = UserRepository(),
        budgetRepository: BudgetCategoryRepositoryDelegate = BudgetCategoryRepository()
    ) {
        self.userRepository = userRepository
        self.budgetRepository = budgetRepository
    }
    
    func setCurrentUser( _ currentUser : UserDataModel){
        self.currentUser =  currentUser
    }
    
    private func handleAddCardOutput(_ output : AddCardOutput){
        switch output{
        case .success(let budgets):
            handleInput(.addCategory(budgets))
        case .failure(let error):
            Log.e(error: error)
        }
    }
    
    var subscriptions =  Set<AnyCancellable>()
    
    private func handleAddCategoryOutput(_ output : AddCategoryOutput){
        switch output{
        case .success(let output):
            addCardRegistrationComplete.send(output)
            try! userRepository.fetch()
                .sink { userCd in
                    Log.s(content: userCd.toUserModel())
                }
                .store(in: &subscriptions
                )
        case .failure(let error):
            Log.e(error: error)
        }
    }
    
}

extension FirstCardViewModel  : FirstCardType {
    
    func handleInput(_ input: FirstCardInput) {
        switch input {
        case .addCard(let cardHolder, let authBudgets):
            useCase.addCard(with: cardHolder, and: authBudgets, for: currentUser.id)
        case .addCategory(let budgetCategoryDataModel):
            if budgetCategoryDataModel.isEmpty{
                addCardRegistrationComplete.send(true)
            }else{
                useCase.addCategorie(budgetCategoryDataModel)
            }
        }
    }
}

extension FirstCardViewModel : FirstCardUseCaseDelegate {
    
    func handleOutput(_ output: FirstCardOutput) {
        switch output {
        case .addCard(let result):
            handleAddCardOutput(result)
        case .addCategories(let output):
            handleAddCategoryOutput(output)
        }
    }
}
