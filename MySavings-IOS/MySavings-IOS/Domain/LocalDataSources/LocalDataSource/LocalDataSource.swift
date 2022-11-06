//
//  LocalRepository.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 03/11/2022.
//

import Foundation
import Combine
import CoreData


typealias RepoResult = (Result<Bool,Error>) -> Void

protocol LocalDataSource  {
    
    associatedtype CD : NSManagedObject
    associatedtype Model : DataSourceModelDelegate
        
    func create(_ data : Model) throws
    
    func readAll() throws -> AnyPublisher<CD,Never>
    
    func read(with id : String ) throws -> AnyPublisher<CD,Never>
    
    func update(with model : Model, completion : @escaping RepoResult)
    
    func delete(with id : String) -> Bool
    
    
}
