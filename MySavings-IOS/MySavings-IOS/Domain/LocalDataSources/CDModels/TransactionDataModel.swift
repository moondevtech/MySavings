//
//  TransactionDataModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation

struct TransactionDataModel : DataSourceModelDelegate, Equatable, Hashable {
    
    var id : String
    var amount : Double
    var transactionDate : Date
    var transactionTitle : String
}
