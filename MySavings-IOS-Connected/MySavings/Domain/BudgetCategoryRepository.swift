//
//  BudgetCategoryRepository.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation
import Combine

struct BudgetCategoryRepository<DataSource : BudgetCategoryDataSourceDelegate> : BudgetCategoryRepositoryDelegate{
    
    var dataSource : DataSource
    
    
    init(dataSource:  DataSource = BudgetCategoryDataSource()) {
        self.dataSource = dataSource
    }

    func create(_ data: BudgetCategoryDataModel) throws {
        try dataSource.create(data as! DataSource.Model)
    }
    
    func fetchAll() throws -> AnyPublisher<BudgetCategoryCD, Never> {
        return try dataSource
            .readAll()
            .map{ $0 as! BudgetCategoryCD }
            .eraseToAnyPublisher()
    }
    
}
