//
//  ApiTransaction.swift
//  MySavings
//
//  Created by Ruben Mimoun on 14/12/2022.
//

import Foundation

struct ApiTransaction : Codable {
    var id : UUID = UUID()
    var transactionDate : TimeInterval
    var transactionTitle : String = ""
    var amount : Double = 0.0
    var budgetId : String
}
