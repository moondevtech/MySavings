//
//  HistoryTransactionModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 21/11/2022.
//

import Foundation


struct HistoryTransactionModel : Identifiable , Equatable, Hashable {
    var id : UUID = .init()
    var transaction : TransactionDataModel
    var offset : CGFloat =  -600
}
