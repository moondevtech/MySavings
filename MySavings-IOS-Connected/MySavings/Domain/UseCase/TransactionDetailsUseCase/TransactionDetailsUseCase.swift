//
//  TransactionUseCase.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation
import Combine

class TransactionDetailsUseCase {
    
    weak var delegate : TransactionOutputType?
    var userRepository : UserRepositoryDelegate
    var subscriptions : Set<AnyCancellable> = .init()
    @CurrentUser var user
    
    
    init(delegate : TransactionOutputType, userRepository : UserRepositoryDelegate =  UserRepository()) {
        self.delegate = delegate
        self.userRepository = userRepository
    }
    
    func start(with data : [TransactionDataModel]){
        data
            .publisher
            .map { transaction in
               return  TransactionScreenModel(transaction: transaction, isOpen: false)
            }
            .flatMap(maxPublishers : .max(1)){
                Just($0)
                    .delay(for: 0.1, scheduler: DispatchQueue.main)
            }
            .sink{[weak self] screenModel in
                self?.delegate?.handleOutput(.started(screenModel))
            }
            .store(in: &subscriptions)
    }
    
    func removeTransaction(_ data : TransactionDataModel){
        if let cUser =  user.userCd{
            let budgets = cUser.unwrappedCards
                .flatMap { $0.unwrappedBudget }
            
            let transactions = budgets
                .flatMap{$0.unwrappedTransactions}
            
            if let transactionCd = transactions.first(where: {$0.id == data.id}){
                
                if let budgetCd =  budgets.first(where: {$0.unwrappedTransactions.contains(transactionCd)}){
                    budgetCd.removeFromTransactions(transactionCd)
                    
                    do{
                        try PersistenceController.shared.save()
                        delegate?.handleOutput(.remove(.success((true, data))))
                        
                    } catch {
                        delegate?.handleOutput(.remove(.failure(error)))
                    }
                }else{
                    delegate?.handleOutput(.remove(.success((false, data))))
                }
            }
        }
    }
    
    func updateUser(){
        do{
            try userRepository.fetch()
                .sink(receiveValue: { [weak self] _ in
                    self?.delegate?.handleOutput(.userUpdated(.success(true)))
                })
                .store(in: &subscriptions)
        }catch{
            delegate?.handleOutput(.userUpdated(.failure(error)))
        }
    }
    
}
