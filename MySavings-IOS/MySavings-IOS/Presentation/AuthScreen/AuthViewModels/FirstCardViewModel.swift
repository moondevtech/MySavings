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

class FirstCardViewModel : ObservableObject {
    
    @CurrentUser var currentUser
   // private var currentUser : UserDataModel!
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
       // self.currentUser =  currentUser
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
