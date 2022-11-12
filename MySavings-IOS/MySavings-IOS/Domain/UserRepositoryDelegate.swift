//
//  UserRepositoryDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation
import Combine

protocol UserRepositoryDelegate {
    
    func create(_ data : UserDataModel) throws
    
    func fetch() throws -> AnyPublisher<UserCD, Never>
    
    func fetch(with id : String)  throws -> AnyPublisher<UserCD, Never>
    
    func removeCard(_ id : String) throws -> AnyPublisher<Bool, Never>
    
}
