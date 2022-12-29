//
//  UserRepository.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine
import CoreData


class UserLocalDataSource : UserDataSourceDelegate {
    
    enum UserDataSourceError : LocalizedError {
        case error(Error), couldNotDelete
    }
    
    func create(_ data: UserDataModel) throws {
        let userCd = UserCD(context: PersistenceController.shared.container.viewContext)
        userCd.id = data.id
        userCd.username = data.username
        userCd.password = data.password
        
        try PersistenceController.shared.save()

    }
    
    
    func readAll() throws -> AnyPublisher<CD, Never> {
        let fetchRequest =  CD.fetchRequest()
        fetchRequest.fetchBatchSize = 10
        return try PersistenceController.shared.context
            .fetch(fetchRequest)
            .publisher
            .map { cd in
                cd
            }
            .eraseToAnyPublisher()
    }
    
    func read(with id: String) throws -> AnyPublisher<CD, Never>{
        let fetchRequest =  CD.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@",id)
        return try PersistenceController.shared.container.viewContext
                .fetch(fetchRequest)
                .publisher
                .map { cd in
                    cd
                }
                .filter{$0.id == id}
                .eraseToAnyPublisher()
    }
    
    
    func update(with model : Model, completion : @escaping RepoResult){
        let fetchRequest =  CD.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id)
        
        PersistenceController.shared.container.performBackgroundTask { context in
            do{
                if let fetched = try context.fetch(fetchRequest).first{
                    fetched.id = model.id
                    fetched.password = model.password
                    fetched.registrationDate = model.registrationDate
                    fetched.username = model.username
                    
                    let cards = model.cards.map { model in
                        let card = CreditCardCD(context: PersistenceController.shared.backgroundContext)
                        card.id = model.id
                        card.owner = fetched
                        card.expirationDate = model.expirationDate
                        card.cardHolder = model.cardHolder
                        card.cardNumber = model.cardNumber
                        card.accountNumber = model.accountNumber
                        card.cvv = model.cvv
                        
                        
                        let budgets =  model.budgets?.map{ budget in
                            let budgetCD =   BudgetCD(context: context)
                            budgetCD.id = budget.id
                            budgetCD.name = budget.name
                            budgetCD.amountSpent = budget.amountSpent
                            budgetCD.maxAmount =  budget.maxAmount
                            budgetCD.fromCard = card
                            return budgetCD
                        }
                        
                        card.budgets = NSSet(array: budgets ?? [])
                        
                        return card
                    }
                    
                    fetched.cards = NSSet(array: cards)
                    
                    try context.save()
                    completion(.success(true))
                }
                
            }catch{
                Log.e(error: error)
                completion(.failure(error))
            }
        }
        
    }
    
    func delete(with id: String) -> Bool {
        let fetchRequest =  CD.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do{
            if let toDelete = try PersistenceController.shared.context.fetch(fetchRequest).first{
                PersistenceController.shared.context.delete(toDelete)
                return true
            }
        }catch{
            Log.e(error: error)
            return false
        }
        return false
    }
    
    typealias CD = UserCD
    
    typealias Model = UserDataModel
    
    
    
    
}
