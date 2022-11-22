//
//  BudgetCategoryDataSource.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation
import Combine


class BudgetCategoryDataSource  : BudgetCategoryDataSourceDelegate {
    
    typealias CD = BudgetCategoryCD
    
    typealias Model = BudgetCategoryDataModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    func create(_ data: Model) throws {
        let budgetCd =  BudgetCategoryCD(context: PersistenceController.shared.context)
        budgetCd.id = data.id
        budgetCd.createdAt = data.createdAt
        budgetCd.name = data.categoryName
        
        try PersistenceController.shared.context.save()
    }
    
    func readAll() throws -> AnyPublisher<BudgetCategoryCD, Never> {
        let fetchRequest =  BudgetCategoryCD.fetchRequest()
        fetchRequest.fetchBatchSize = 5
        
        return try PersistenceController.shared.context.fetch(fetchRequest)
            .publisher
            .eraseToAnyPublisher()
    }
    
    func read(with id: String) throws -> AnyPublisher<BudgetCategoryCD, Never> {
        let fetchRequest =  BudgetCategoryCD.fetchRequest()
        fetchRequest.fetchBatchSize = 5
        fetchRequest.predicate = NSPredicate(format: "id == @%", id)
        
        return try PersistenceController.shared.context.fetch(fetchRequest)
            .publisher
            .filter{$0.id == id}
            .first()
            .eraseToAnyPublisher()
    }
    
    func update(with model: Model, completion: @escaping RepoResult) {
        let fetchRequest =  BudgetCategoryCD.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "id == @%", model.id)
        
        PersistenceController.shared.container.performBackgroundTask { context in
            do{
                let results = try context.fetch(fetchRequest)
                if var toUpdate = results.first{
                    toUpdate.id = model.id
                    toUpdate.createdAt = model.createdAt
                    toUpdate.name = model.categoryName
                    try context.save()
                    completion(.success(true))
                }else{
                    completion(.success(false))
                }
            }catch{
                completion(.failure(error))
            }
        }
    }
    
    
    func delete(with id: String) -> Bool {
        let fetchRequest =  BudgetCategoryCD.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "id == @%", id)
        do{
            if let results = try PersistenceController.shared.context.fetch(fetchRequest).first{
                PersistenceController.shared.context.delete(results)
                return true
            }
            return false
        }catch{
            Log.e(error: error)
            return false
        }
    }
    
    
}
