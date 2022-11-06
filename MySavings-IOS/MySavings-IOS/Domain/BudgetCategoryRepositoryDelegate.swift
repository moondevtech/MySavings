//
//  BudgetCategoryRepositoryDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 06/11/2022.
//

import Foundation
import Combine

protocol BudgetCategoryRepositoryDelegate {
    
    func create(_ data : BudgetCategoryDataModel) throws
    
    func fetchAll() throws -> AnyPublisher<BudgetCategoryCD,Never>
    
}
