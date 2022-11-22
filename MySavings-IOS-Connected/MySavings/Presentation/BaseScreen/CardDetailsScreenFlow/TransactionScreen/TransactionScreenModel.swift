//
//  TransactionScreenModel.swift
//  MySavings-IOS
//
//  Created by Ruben Mimoun on 19/11/2022.
//

import Foundation

struct TransactionScreenModel : Identifiable, Equatable, Hashable {
    var id : UUID = .init()
    var transaction : TransactionDataModel = .init(id: "", amount: 0.0, transactionDate:.init(), transactionTitle: "")
    var offset : CGFloat = -600
    var slidingOffset : CGFloat = 0
    var isOpen : Bool = false
}
