//
//  TransactionDataModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 05/11/2022.
//

import Foundation

struct TransactionDataModel : DataSourceModelDelegate {
    
    var id : String
    var amount : Double
    var transactionData : Date
    var transactionTitle : String
}
