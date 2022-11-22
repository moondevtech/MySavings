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
    
    
    private func handleAddCardOutput(_ output : AddCardOutput){
        switch output{
        case .success(let budgets):
            updateCurrentUser()
            handleInput(.addCategory(budgets))
        case .failure(let error):
            Log.e(error: error)
        }
    }
    
    var subscriptions =  Set<AnyCancellable>()
    
    private func handleAddCategoryOutput(_ output : AddCategoryOutput){
        switch output{
        case .success(let output):
            updateCurrentUser()
            addCardRegistrationComplete.send(output)
        case .failure(let error):
            Log.e(error: error)
        }
    }
    
    private func updateCurrentUser(){
        try! userRepository.fetch()
            .sink { _ in}
            .store(in: &subscriptions)
    }
    
}

extension FirstCardViewModel  : FirstCardType {
    
    func handleInput(_ input: FirstCardInput) {
        switch input {
        case .addCard(let cardHolder, let authBudgets):
            useCase.addCard(with: cardHolder, and: authBudgets, for: currentUser.value.userDataModel.id)
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
