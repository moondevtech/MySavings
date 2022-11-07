//
//  BudgetDataModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation

struct BudgetDataModel : DataSourceModelDelegate {

    var id: String
    var name: String
    var amountSpent: Double
    var maxAmount: Double
    var transactions : [TransactionDataModel]?
}

extension BudgetDataModel {
    
}
