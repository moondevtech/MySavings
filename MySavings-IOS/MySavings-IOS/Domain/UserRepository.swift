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
       try dataSource.readAll().compactMap{ current in
               ( current as! UserCD)
        }
        .eraseToAnyPublisher()
     
    }
    
    func fetch(with id: String) throws -> AnyPublisher<UserCD, Never> {
        let shared = try dataSource.read(with: id)
            .compactMap{current in
                ( current as! UserCD)
            }
            .share()
        
        shared.receive(on: DispatchQueue.main)
            .sink {[weak self] cd in
                self?.currentUserCd = cd
            }
            .store(in: &subscriptions)
        
        
        return  shared
            .eraseToAnyPublisher()
    }
    
    
    
}
