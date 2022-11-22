//
//  BudgetDataModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation

struct BudgetDataModel : DataSourceModelDelegate, Hashable, Equatable {

    var id: String
    var name: String
    var amountSpent: Double
    var maxAmount: Double
    var transactions : [TransactionDataModel]?
    var isSelected = false
    
    var realAmountSpent : Double {
        transactions?
            .compactMap{$0}
            .map{$0.amount}
            .reduce(0.0, { acc, next in
            acc + next
        }) ?? 0.0
    }
}

extension BudgetDataModel {
    
}
