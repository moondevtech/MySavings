//
//  ExpensesTransactionType.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 20/11/2022.
//

import Foundation

protocol ExpensesTransactionType {
    
    func handleTransactions(with input : ExpensesTransactionInput)
    
}
