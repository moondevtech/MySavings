//
//  UserRepository.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation
import Combine

class UserRepository<DataSource : UserDataSourceDelegate> : UserRepositoryDelegate {
    
    private var currentUserCd : UserCD?
    private let dataSource :   DataSource
    var subscriptions  = Set<AnyCancellable>()
    
    init(dataSource:  DataSource = UserLocalDataSource()) {
        self.dataSource = dataSource
    }
    
    func create(_ data: UserDataModel) throws {
       try dataSource.create(data as! DataSource.Model )
    }
    
    func fetch() throws -> AnyPublisher<UserCD, Never> {
       try dataSource.readAll()
            .compactMap{ current in
               ( current as! UserCD)
        }
        .eraseToAnyPublisher()
     
    }
    
    func fetch(with id: String) throws -> AnyPublisher<UserCD, Never> {
        Log.i(content: "\(id)")
        return try dataSource.read(with: id)
            .compactMap{[weak self] current in
                let user =  ( current as! UserCD)
                self?.currentUserCd = user
                return user
            }
            .eraseToAnyPublisher()
    }
    
    
    
}
