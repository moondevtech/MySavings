//
//  ExpensesTransactionUseCaseDelegate.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 20/11/2022.
//

import Foundation
import Combine

protocol ExpensesTransactionUseCaseDelegate : AnyObject {
    
    func graphTransactions(with result : AnyPublisher<ExpenseGraphModel, Never>)
    
    func cardUsedForPayments(with result : AnyPublisher<[CardModel], Never>)

}
