//
//  UserRepository.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation
import Combine

class UserRepository<DataSource : UserDataSourceDelegate> : UserRepositoryDelegate {
    
    @CurrentUser var user
    private let dataSource :   DataSource
    var subscriptions  = Set<AnyCancellable>()
    
    init(dataSource:  DataSource = UserLocalDataSource()) {
        self.dataSource = dataSource
    }
    
    private func updateUserSource(_ userCd : UserCD){
        self.user[keyPath: \.userCd] = userCd
        self.user[keyPath : \.userDataModel ] = userCd.toUserModel()
    }
    
    func create(_ data: UserDataModel) throws {
        try dataSource.create(data as! DataSource.Model)
    }
    
    func fetch() throws -> AnyPublisher<UserCD, Never> {
        try dataSource.readAll()
            .compactMap{current in
                let user =   ( current as! UserCD)
                return user
            }
            .handleEvents(receiveOutput: {[weak self] userCd in
                self?.updateUserSource(userCd)
            })
            .eraseToAnyPublisher()
        
    }
    
    func fetch(with id: String) throws -> AnyPublisher<UserCD, Never> {
         try dataSource.read(with: id)
            .compactMap{ current in
                let user =  ( current as! UserCD)
                return user
            }
            .handleEvents(receiveOutput: {[weak self] userCd in
                self?.updateUserSource(userCd)
            })
            .eraseToAnyPublisher()
    }
    
    
    func removeCard(_ id : String) throws -> AnyPublisher<Bool, Never>{
         try fetch()
            .map{ obj -> (UserCD, CreditCardCD)? in
                if let card =  (obj.cards?.allObjects as? [CreditCardCD])?.first(where: {$0.id == id}){
                    return (obj, card)
                }else{
                    return nil
                }
            }
            .handleEvents(receiveOutput: {[weak self] result in
                if let result = result{
                    result.0.removeFromCards(result.1)
                    try! PersistenceController.shared.save()
                    self?.updateUserSource(result.0)
                }
            })
            .map { result in
                return result != nil
            }
            .eraseToAnyPublisher()
    }
    
    
}
